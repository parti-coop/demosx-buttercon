package seoul.democracy.site.restcontroller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import seoul.democracy.common.dto.ResultInfo;
import seoul.democracy.common.dto.ResultRedirectInfo;
import seoul.democracy.salon.domain.Salon;
import seoul.democracy.salon.dto.SalonCreateDto;
import seoul.democracy.salon.dto.SalonUpdateDto;
import seoul.democracy.salon.service.SalonService;

import javax.validation.Valid;

@RestController
@RequestMapping("/ajax/salon")
public class SalonAjaxController {

    private final SalonService salonService;

    @Autowired
    public SalonAjaxController(SalonService salonService) {
        this.salonService = salonService;
    }

    @RequestMapping(value = "/", method = RequestMethod.POST)
    public ResultRedirectInfo newSalon(@RequestBody @Valid SalonCreateDto createDto) throws Exception {
        Salon salon = salonService.create(createDto);

        return ResultRedirectInfo.of("아이디어를 등록하였습니다.", "/content.do?id=" + salon.getId());
    }

    @RequestMapping(value = "/{id}", method = RequestMethod.PUT)
    public ResultInfo editSalon(@PathVariable("id") Long id, @RequestBody @Valid SalonUpdateDto updateDto) {
        salonService.update(updateDto);

        return ResultInfo.of("아이디어를 수정하였습니다.");
    }

    @RequestMapping(value = "/{id}", method = RequestMethod.DELETE)
    public ResultInfo deleteSalon(@PathVariable("id") Long id) {
        salonService.delete(id);

        return ResultInfo.of("아이디어를 삭제하였습니다.");
    }

    @RequestMapping(value = "/{id}/selectLike", method = RequestMethod.PUT)
    public ResultInfo selectLikeSalon(@PathVariable("id") Long id) {
        salonService.selectLike(id);

        return ResultInfo.of("공감하였습니다.");
    }

    @RequestMapping(value = "/{id}/deselectLike", method = RequestMethod.PUT)
    public ResultInfo deselectLikeSalon(@PathVariable("id") Long id) {
        salonService.deselectLike(id);

        return ResultInfo.of("공감해제하였습니다.");
    }
}
