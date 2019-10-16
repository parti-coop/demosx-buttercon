package seoul.democracy.butter.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.mysema.query.types.Projections;
import com.mysema.query.types.QBean;
import lombok.Data;
import seoul.democracy.issue.domain.Issue;
import seoul.democracy.issue.domain.IssueGroup;
import seoul.democracy.issue.domain.IssueType;
import seoul.democracy.issue.dto.CategoryDto;
import seoul.democracy.issue.dto.IssueDto;
import seoul.democracy.issue.dto.IssueFileDto;
import seoul.democracy.issue.dto.IssueStatsDto;
import seoul.democracy.opinion.domain.OpinionType;
import seoul.democracy.user.dto.UserDto;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import static seoul.democracy.butter.domain.QButter.butter;

@Data
public class ButterDto {

    public final static QBean<ButterDto> projection = Projections.fields(ButterDto.class,
        butter.id, butter.createdDate, butter.modifiedDate,
        UserDto.projectionForBasicByCreatedBy.as("createdBy"),
        UserDto.projectionForBasicByModifiedBy.as("modifiedBy"),
        butter.createdIp, butter.modifiedIp, butter.opinionType,
        CategoryDto.projection.as("category"),
        IssueStatsDto.projection.as("stats"),
        butter.group, butter.status, 
         butter.title, butter.excerpt, butter.content
        );

    /**
     * 관리자 토론 리스트에서 사용
     */
    public final static QBean<ButterDto> projectionForAdminList = Projections.fields(ButterDto.class,
        butter.id, butter.createdDate,
        UserDto.projectionForBasicByCreatedBy.as("createdBy"),
        butter.opinionType,
        CategoryDto.projection.as("category"),
        IssueStatsDto.projection.as("stats"),
        butter.status,  butter.title);

    /**
     * 관리자 토론 상세에서 사용
     */
    public final static QBean<ButterDto> projectionForAdminDetail = Projections.fields(ButterDto.class,
        butter.id, butter.createdDate,
        UserDto.projectionForBasicByCreatedBy.as("createdBy"),
        butter.opinionType,
        CategoryDto.projection.as("category"),
        IssueStatsDto.projection.as("stats"),
        butter.group, butter.status, 
         butter.title, butter.excerpt, butter.content
        );

    /**
     * 토론 선택용으로 사용
     */
    public final static QBean<ButterDto> projectionForAdminSelect = Projections.fields(ButterDto.class,
        butter.id, butter.title);

    /**
     * 토론 리스트에서 사용
     */
    public final static QBean<ButterDto> projectionForSiteList = Projections.fields(ButterDto.class,
        butter.id, butter.opinionType,
        CategoryDto.projectionForFilter.as("category"),
        IssueStatsDto.projection.as("stats"),
        butter.group,   butter.title, butter.excerpt);

    /**
     * 토론 상세에서 사용
     */
    public final static QBean<ButterDto> projectionForSiteDetail = Projections.fields(ButterDto.class,
        butter.id, butter.opinionType,
        CategoryDto.projection.as("category"),
        butter.statsId, IssueStatsDto.projection.as("stats"),
        butter.group,   butter.title, butter.content);

    private Long id;
    @JsonFormat(pattern = "yyyy-MM-dd")
    private LocalDateTime createdDate;
    private LocalDateTime modifiedDate;
    private UserDto createdBy;
    private UserDto modifiedBy;
    private String createdIp;
    private String modifiedIp;
    private OpinionType opinionType;

    private CategoryDto category;

    private Long statsId;
    private IssueStatsDto stats;
    private List<IssueFileDto> files;

    private IssueGroup group;
    private Issue.Status status;

    private String thumbnail;
    private String title;
    private String excerpt;
    private String content;

    private LocalDate startDate;
    private LocalDate endDate;

    private List<Long> relations;
    private Map<Long, IssueDto> issueMap;

    public List<IssueDto> viewProposals() {
        return relations.stream()
                   .map(relation -> issueMap.get(relation))
                   .filter(relation -> relation.getType() == IssueType.P)
                   .collect(Collectors.toList());
    }

    public List<IssueDto> viewDebates() {
        return relations.stream()
                   .map(relation -> issueMap.get(relation))
                   .filter(relation -> relation.getType() == IssueType.D)
                   .collect(Collectors.toList());
    }
}
