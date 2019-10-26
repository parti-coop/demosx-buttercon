package seoul.democracy.butter.service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

import javax.json.Json;
import javax.json.JsonObject;
import javax.mail.internet.ContentType;

import com.mysema.query.types.Expression;
import com.mysema.query.types.Predicate;

import org.apache.commons.validator.routines.UrlValidator;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import lombok.extern.slf4j.Slf4j;
import seoul.democracy.butter.domain.Butter;
import seoul.democracy.butter.dto.ButterCreateDto;
import seoul.democracy.butter.dto.ButterDto;
import seoul.democracy.butter.dto.ButterUpdateDto;
import seoul.democracy.butter.predicate.ButterPredicate;
import seoul.democracy.butter.repository.ButterRepository;
import seoul.democracy.common.exception.NotFoundException;
import seoul.democracy.history.domain.IssueHistory;
import seoul.democracy.history.repository.IssueHistoryRepository;
import seoul.democracy.issue.repository.IssueStatsRepository;
import seoul.democracy.issue.service.IssueTagService;
import seoul.democracy.user.domain.User;
import seoul.democracy.user.repository.UserRepository;
import seoul.democracy.user.utils.UserUtils;

@Slf4j
@Service
@Transactional(readOnly = true)
public class ButterService {

    @Autowired
    private ButterRepository butterRepository;
    @Autowired
    private IssueHistoryRepository issueHistoryRepository;
    @Autowired
    private UserRepository userRepository;
    @Autowired
    private IssueTagService issueTagService;
    @Autowired
    private IssueStatsRepository statsRepository;

    public ButterDto getButter(Predicate predicate, Expression<ButterDto> projection) {
        return butterRepository.findOne(predicate, projection);
    }

    public List<ButterDto> getButters(Predicate predicate, Expression<ButterDto> projection) {
        return butterRepository.findAll(predicate, projection);
    }

    public List<ButterDto> getButters(Expression<ButterDto> projection) {
        Predicate predicate = ButterPredicate.predicateForSiteList();
        return butterRepository.findAll(predicate, projection);
    }

    public List<ButterDto> getButtersMine(Expression<ButterDto> projection) {
        Predicate predicate = ButterPredicate.predicateForSiteListMine();
        return butterRepository.findMine(predicate, projection);
    }

    /**
     * 버터문서 등록
     */
    @Transactional
    public Butter create(ButterCreateDto dto) {
        Butter butter = Butter.create(dto);
        Long[] makerIds = dto.getMakerIds();
        if (makerIds != null && makerIds.length > 0) {
            for (Long id : makerIds) {
                User user = userRepository.findOne(id);
                butter.addMaker(user);
            }
        }
        /** 아무도 없으면 문서를 만든 사람을 넣는다 */
        else {
            butter.addMaker(UserUtils.getLoginUser());
        }
        butter = butterRepository.save(butter);
        issueHistoryRepository.save(butter.createHistory(butter.getContent(), dto.getExcerpt()));
        statsRepository.increaseYesOpinion(butter.getId()); // 버터 추가횟수 증가
        issueTagService.changeIssueTags(butter.getId(), dto.getIssueTagNames());
        String msg = "버터 등록: *<https://butterknifecrew.kr/butter.do?id=" + butter.getId() + "|" + butter.getTitle()
                + ">*";
        sendSlackWebHook(butter.getSlackUrl(), butter.getSlackChannel(), msg);
        return butter;
    }

    private void sendSlackWebHook(String url, String channel, String text) {
        try {
            UrlValidator urlValidator = new UrlValidator();
            Boolean isValidUrl = urlValidator.isValid(url);
            if (isValidUrl == false) {
                return;
            }
            URL object = new URL(url);
            HttpURLConnection con = (HttpURLConnection) object.openConnection();
            con.setDoOutput(true);
            con.setRequestProperty("Content-Type", "application/json");
            con.setRequestProperty("Accept", "application/json");
            con.setRequestMethod("POST");

            JsonObject body = Json.createObjectBuilder().add("text", text).add("channel", channel).build();

            OutputStreamWriter wr = new OutputStreamWriter(con.getOutputStream());
            wr.write(body.toString());
            wr.flush();

            // display what returns the POST request

            StringBuilder sb = new StringBuilder();
            int HttpResult = con.getResponseCode();
            if (HttpResult == HttpURLConnection.HTTP_OK) {
                BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream(), "utf-8"));
                String line = null;
                while ((line = br.readLine()) != null) {
                    sb.append(line + "\n");
                }
                br.close();
                System.out.println("" + sb.toString());
            } else {
                System.out.println(HttpResult + ": " + con.getResponseMessage());
            }
        } catch (Exception e) {
            return;
        }
    }

    /**
     * 버터문서 수정
     */
    @Transactional
    public Butter update(ButterUpdateDto dto) {
        Butter butter = butterRepository.findOne(dto.getId());
        if (butter == null)
            throw new NotFoundException("해당 버터를 찾을 수 없습니다.");

        Boolean wasMaker = butter.getButterMakers().stream().anyMatch(u -> u.getId().equals(UserUtils.getUserId()));
        if (wasMaker) {
            issueTagService.changeIssueTags(butter.getId(), dto.getIssueTagNames());
            changeMakers(butter, dto.getMakerIds());
        }
        boolean changedContent = dto.getContent() != null && !dto.getContent().equals(butter.getContent());
        boolean hasExcerpt = StringUtils.hasText(dto.getExcerpt());
        /** 본문 수정이나 요약이 없으면 발행이력에 넣지 않고 슬랙도 쏘지 않는다. */
        if (changedContent || hasExcerpt) {
            IssueHistory history = issueHistoryRepository
                    .save(butter.createHistory(dto.getContent(), dto.getExcerpt()));
            butter = butter.update(dto, wasMaker);
            /** 요약이 없으면 발행이력에는 넣지만 슬랙은 쏘지 않는다. */
            if (hasExcerpt) {
                String msg = "버터 수정: *<https://butterknifecrew.kr/butter.do?id=" + butter.getId() + "|"
                        + butter.getTitle() + ">*\n> <https://butterknifecrew.kr/butter-history.do?id="
                        + history.getId() + "|" + history.getExcerpt() + ">";
                sendSlackWebHook(butter.getSlackUrl(), butter.getSlackChannel(), msg);
            }
            statsRepository.increaseYesOpinion(butter.getId()); // 수정횟수 증가
        }
        return butter;
    }

    /**
     * 버터문서 삭제
     */
    @Transactional
    public void remove(Long id) {
        Butter butter = butterRepository.findOne(id);
        if (butter == null)
            throw new NotFoundException("해당 버터를 찾을 수 없습니다.");

        Boolean wasMaker = butter.getButterMakers().stream().anyMatch(u -> u.getId().equals(UserUtils.getUserId()));
        if (wasMaker) {
            butter.delete();
            String msg = "버터 삭제: *" + butter.getTitle() + "*";
            sendSlackWebHook(butter.getSlackUrl(), butter.getSlackChannel(), msg);
        } else {
            throw new NotFoundException("해당 버터의 메이커가 아닙니다.");
        }
    }

    /**
     * 메이커 업데이트
     */
    @Transactional
    public void changeMakers(Butter butter, final Long[] ids) {
        if (ids == null || ids.length == 0) {
            butter.removeAllMaker();
            butter.addMaker(UserUtils.getLoginUser());
            return;
        }
        for (Long id : ids) {
            User user = userRepository.findOne(id);
            butter.addMaker(user);
        }

        List<User> removedMakers = butter.getButterMakers().stream()
                .filter(m -> !Arrays.stream(ids).anyMatch(m.getId()::equals)).collect(Collectors.toList());
        for (User removedMaker : removedMakers) {
            butter.removeMaker(removedMaker);
        }
        butterRepository.save(butter);
    }

}
