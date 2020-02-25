package seoul.democracy.common.service;

import lombok.extern.slf4j.Slf4j;
import net.coobird.thumbnailator.Thumbnails;
import net.coobird.thumbnailator.geometry.Positions;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;
import seoul.democracy.common.dto.UploadFileInfo;
import seoul.democracy.common.dto.UploadFileType;
import seoul.democracy.common.exception.BadRequestException;
import seoul.democracy.common.exception.NotFoundException;

import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.UUID;

import javax.imageio.ImageIO;

import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import com.amazonaws.regions.Regions;
import com.amazonaws.services.s3.model.CannedAccessControlList;
import com.amazonaws.services.s3.model.ObjectMetadata;
import com.amazonaws.services.s3.model.PutObjectRequest;

@Slf4j
@Service
public class StorageService {

    private final DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("yyyy/MM");
    private final String bucketName = "butterknifecrew";
    private final AmazonS3 s3client = AmazonS3ClientBuilder.standard().withRegion(Regions.AP_NORTHEAST_2).build();

    public UploadFileInfo store(UploadFileType type, MultipartFile multipartFile) {
        if (multipartFile.isEmpty()) {
            throw new NotFoundException("empty file : " + multipartFile.getOriginalFilename());
        }

        /* save file */
        try {
            String originalFileName = multipartFile.getOriginalFilename();
            String filename = UUID.randomUUID().toString().replace("-", "") + "."
                    + StringUtils.getFilenameExtension(originalFileName);

            String uploadPath = LocalDate.now().format(dateTimeFormatter);

            // File file = new File(this.systemUploadPath + uploadPath, filename);
            // if (!file.getParentFile().exists())
            // file.getParentFile().mkdirs();
            ObjectMetadata metadata = new ObjectMetadata();
            InputStream iStream;
            if (type == UploadFileType.ORIGINAL) {

                // FileCopyUtils.copy(multipartFile.getBytes(), file);
                // request = new PutObjectRequest(bucketName, uploadPath + "/" + filename,
                iStream = multipartFile.getInputStream();
                metadata.setContentLength(multipartFile.getSize());
                // metadata);

            } else {
                BufferedImage sourceImg = Thumbnails.of(multipartFile.getInputStream()).scale(1).asBufferedImage();
                BufferedImage targetImg;
                ByteArrayOutputStream os = new ByteArrayOutputStream();

                if (sourceImg == null)
                    throw new BadRequestException("file", "error.file", "이미지 파일이 아닙니다.");

                if (type.getHeight() == 0) {
                    if (sourceImg.getWidth() > type.getWidth()) {
                        targetImg = Thumbnails.of(sourceImg).width(type.getWidth()).asBufferedImage();
                    } else {
                        targetImg = Thumbnails.of(sourceImg).scale(1).asBufferedImage();
                    }
                } else {
                    targetImg = Thumbnails.of(sourceImg).size(type.getWidth(), type.getHeight()).crop(Positions.CENTER)
                            .keepAspectRatio(true).asBufferedImage();
                }
                ImageIO.write(targetImg, "jpeg", os);
                metadata.setContentLength(os.size());
                iStream = new ByteArrayInputStream(os.toByteArray());
            }
            String url = "/files/" + uploadPath + "/" + filename;
            try {
                PutObjectRequest request = new PutObjectRequest(bucketName, url.substring(1), iStream, metadata);
                request.setCannedAcl(CannedAccessControlList.PublicRead);
                s3client.putObject(request);
            } catch (Exception e) {
                log.error(e.getMessage());
            }
            return UploadFileInfo.of(originalFileName, url);
        } catch (IOException e) {
            log.info("{}", e);
            throw new BadRequestException("file", "error.file", e.getMessage());
        }
    }
}
