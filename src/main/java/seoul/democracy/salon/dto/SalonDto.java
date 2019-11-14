package seoul.democracy.salon.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.mysema.query.types.Projections;
import com.mysema.query.types.QBean;
import lombok.Data;
import seoul.democracy.issue.domain.Issue;
import seoul.democracy.issue.domain.IssueFile;
import seoul.democracy.issue.dto.CategoryDto;
import seoul.democracy.issue.dto.IssueStatsDto;
import seoul.democracy.issue.dto.IssueTagDto;
import seoul.democracy.opinion.domain.OpinionType;
import seoul.democracy.user.dto.UserDto;

import java.time.LocalDateTime;
import java.util.List;

import static seoul.democracy.salon.domain.QSalon.salon;

@Data
@JsonInclude(JsonInclude.Include.NON_NULL)
public class SalonDto {

        public final static QBean<SalonDto> projection = Projections.fields(SalonDto.class, salon.id, salon.createdDate,
                        salon.modifiedDate, UserDto.projectionForBasicByCreatedBy.as("createdBy"),
                        UserDto.projectionForBasicByModifiedBy.as("modifiedBy"), salon.createdIp, salon.modifiedIp,
                        salon.opinionType, CategoryDto.projection.as("category"), IssueStatsDto.projection.as("stats"),
                        salon.salonType, salon.status, salon.process, salon.image, salon.title, salon.content);

        /**
         * 사이트 리스트에서 사용
         */
        public final static QBean<SalonDto> projectionForSiteList = Projections.fields(SalonDto.class, salon.id,
                        salon.createdDate, UserDto.projectionForBasicByCreatedBy.as("createdBy"), salon.image,
                        IssueStatsDto.projection.as("stats"), salon.status, salon.title, salon.excerpt);

        /**
         * 제안 상세에서 사용
         */
        public final static QBean<SalonDto> projectionForSiteDetail = Projections.fields(SalonDto.class, salon.id,
                        salon.createdDate, UserDto.projectionForBasicByCreatedBy.as("createdBy"),
                        CategoryDto.projection.as("category"), salon.statsId, IssueStatsDto.projection.as("stats"),
                        salon.status, salon.process, salon.image, salon.title, salon.content);

        /**
         * 마이페이지에서 사용
         */
        public final static QBean<SalonDto> projectionForMypageSalon = Projections.fields(SalonDto.class, salon.id,
                        salon.createdDate, IssueStatsDto.projection.as("stats"), salon.status, salon.process,
                        salon.title);

        /**
         * 나의 제안 수정 시 사용
         */
        public final static QBean<SalonDto> projectionForSiteEdit = Projections.fields(SalonDto.class, salon.id,
                        salon.title, salon.content, salon.image);

        private Long id;
        @JsonFormat(pattern = "yyyy-MM-dd")
        private LocalDateTime createdDate;
        private LocalDateTime modifiedDate;
        private UserDto createdBy;
        private UserDto modifiedBy;
        private String createdIp;
        private String modifiedIp;
        private OpinionType opinionType;

        private String salonType;
        private CategoryDto category;

        private Long statsId;
        private IssueStatsDto stats;
        private List<IssueFile> files;

        private Issue.Status status;
        private String process;

        private LocalDateTime adminCommentDate;
        private String adminComment;

        private UserDto manager;
        private LocalDateTime managerCommentDate;
        private String managerComment;

        private String title;
        private String excerpt;
        private String content;
        private String image;

        private List<IssueTagDto> issueTags;

        // 제안에 대해 공감 표시 여부
        private Boolean liked;
}
