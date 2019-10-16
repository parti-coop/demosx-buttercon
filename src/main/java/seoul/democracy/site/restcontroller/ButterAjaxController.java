package seoul.democracy.site.restcontroller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import seoul.democracy.common.dto.ResultInfo;
import seoul.democracy.common.dto.ResultRedirectInfo;
import seoul.democracy.butter.domain.Butter;
import seoul.democracy.butter.dto.ButterCreateDto;
import seoul.democracy.butter.dto.ButterUpdateDto;
import seoul.democracy.butter.service.ButterService;
import seoul.democracy.issue.domain.IssueGroup;

import javax.validation.Valid;

@RestController
@RequestMapping("/ajax/butter")
public class ButterAjaxController {

    private final ButterService butterService;

    @Autowired
    public ButterAjaxController(ButterService butterService) {
        this.butterService = butterService;
    }

    @RequestMapping(value = "/", method = RequestMethod.POST)
    public ResultRedirectInfo newButter(@RequestBody @Valid ButterCreateDto createDto) throws Exception {
        Butter butter = butterService.create(IssueGroup.USER, createDto);
        return ResultRedirectInfo.of("아이디어를 등록하였습니다.", "/butter.do?id=" + butter.getId());
    }

    @RequestMapping(value = "/{id}", method = RequestMethod.PUT)
    public ResultInfo editButter(@PathVariable("id") Long id, @RequestBody @Valid ButterUpdateDto updateDto) {
        butterService.update(updateDto);

        return ResultInfo.of("아이디어를 수정하였습니다.");
    }
}
