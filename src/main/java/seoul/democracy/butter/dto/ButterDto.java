package seoul.democracy.butter.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.mysema.query.types.Projections;
import com.mysema.query.types.QBean;

import lombok.Data;

import seoul.democracy.issue.domain.Issue;
import seoul.democracy.issue.domain.IssueGroup;
import seoul.democracy.issue.dto.CategoryDto;
import seoul.democracy.issue.dto.IssueFileDto;
import seoul.democracy.issue.dto.IssueStatsDto;
import seoul.democracy.issue.dto.IssueTagDto;
import seoul.democracy.opinion.domain.OpinionType;
import seoul.democracy.user.dto.UserDto;
import seoul.democracy.user.utils.UserUtils;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

import static seoul.democracy.butter.domain.QButter.butter;

@Data
@JsonInclude(JsonInclude.Include.NON_NULL)
public class ButterDto {

        public final static QBean<ButterDto> projection = Projections.fields(ButterDto.class, butter.id,
                        butter.createdDate, butter.modifiedDate, UserDto.projectionForBasicByCreatedBy.as("createdBy"),
                        UserDto.projectionForBasicByModifiedBy.as("modifiedBy"), butter.createdIp, butter.modifiedIp,
                        butter.opinionType, IssueStatsDto.projection.as("stats"), butter.group, butter.status,
                        butter.title, butter.excerpt, butter.content, butter.slackUrl, butter.slackChannel);

        /**
         * 버터 리스트에서 사용
         */
        public final static QBean<ButterDto> projectionForSiteList = Projections.fields(ButterDto.class, butter.id,
                        butter.modifiedDate, UserDto.projectionForBasicByModifiedBy.as("modifiedBy"), butter.createdIp,
                        butter.modifiedIp, butter.createdDate, butter.excerpt, butter.statsId,
                        UserDto.projectionForBasicByCreatedBy.as("createdBy"), butter.content, butter.status,
                        IssueStatsDto.projection.as("stats"), butter.title, butter.slackUrl, butter.slackChannel);

        /**
         * 내 버터 리스트에서 사용
         */
        public final static QBean<ButterDto> projectionForSiteListMine = Projections.fields(ButterDto.class, butter.id,
                        butter.modifiedDate, UserDto.projectionForBasic.as("modifiedBy"), butter.createdIp,
                        butter.modifiedIp, butter.createdDate, butter.excerpt, butter.statsId,
                        UserDto.projectionForBasic.as("createdBy"), butter.content, butter.status,
                        IssueStatsDto.projection.as("stats"), butter.title, butter.slackUrl, butter.slackChannel);

        /**
         * 버터 상세에서 사용
         */
        public final static QBean<ButterDto> projectionForSiteDetail = Projections.fields(ButterDto.class, butter.id,
                        butter.modifiedDate, UserDto.projectionForBasicByModifiedBy.as("modifiedBy"), butter.createdIp,
                        butter.modifiedIp, butter.createdDate, butter.excerpt, butter.statsId,
                        UserDto.projectionForBasicByCreatedBy.as("createdBy"), butter.content, butter.status,
                        IssueStatsDto.projection.as("stats"), butter.title, butter.slackUrl, butter.slackChannel);

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

        private String slackUrl;
        private String slackChannel;

        private List<IssueTagDto> issueTags;
        private List<UserDto> butterMakers;

        public Boolean isNew() {
                return this.modifiedDate.isAfter(LocalDateTime.now().minusHours(24));
        }

        public Boolean isMaker() {
                if (this.butterMakers == null) {
                        return false;
                }
                Long id = UserUtils.getUserId();
                for (UserDto maker : this.butterMakers) {
                        if (maker.getId().equals(id)) {
                                return true;
                        }
                }
                return false;
        }

}
