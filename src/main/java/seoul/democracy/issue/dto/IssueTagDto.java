package seoul.democracy.issue.dto;

import com.mysema.query.types.Projections;
import com.mysema.query.types.QBean;

import lombok.Data;

import static seoul.democracy.issue.domain.QIssueTag.issueTag;

@Data
public class IssueTagDto {
    public final static QBean<IssueTagDto> projection = Projections.fields(IssueTagDto.class,
        issueTag.id, issueTag.name);

    private Long id;
    private String name;
}
