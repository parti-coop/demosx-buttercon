package seoul.democracy.site.restcontroller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import seoul.democracy.common.dto.ResultInfo;

import seoul.democracy.issue.service.IssueService;

@RestController
@RequestMapping("/ajax/like")
public class LikeAjaxController {

    @Autowired
    private IssueService issueService;

    @RequestMapping(value = "/{id}", method = RequestMethod.PUT)
    public ResultInfo selectLikeSalon(@PathVariable("id") Long id) {
        issueService.increaseLikeCount(id);
        return ResultInfo.of("공감하였습니다.");
    }

}
