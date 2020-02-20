package seoul.democracy.common.service;

import egovframework.rte.fdl.property.EgovPropertyService;
import lombok.extern.slf4j.Slf4j;
import net.coobird.thumbnailator.Thumbnails;
import net.coobird.thumbnailator.geometry.Positions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.FileCopyUtils;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;
import seoul.democracy.common.dto.UploadFileInfo;
import seoul.democracy.common.dto.UploadFileType;
import seoul.democracy.common.exception.BadRequestException;
import seoul.democracy.common.exception.NotFoundException;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.UUID;

import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import com.amazonaws.auth.AWSCredentials;
import com.amazonaws.auth.AWSStaticCredentialsProvider;
import com.amazonaws.auth.BasicAWSCredentials;
import com.amazonaws.regions.Regions;
import com.amazonaws.services.s3.model.ObjectMetadata;
import com.amazonaws.services.s3.model.PutObjectRequest;
import com.mysema.util.FileUtils;

@Slf4j
@Service
public class StorageService {

    private final String systemUploadPath;
    private final DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("yyyy/MM");
    private final String bucketName = "butterknifecrew";
    private final String AWS_ACCESS_KEY;
    private final String AWS_SECRET_KEY;
    private final AmazonS3 s3client;

    @Autowired
    public StorageService(EgovPropertyService propertyService) {
        this.systemUploadPath = propertyService.getString("uploadFilePath");
        this.AWS_ACCESS_KEY = propertyService.getString("AWS_ACCESS_KEY");
        this.AWS_SECRET_KEY = propertyService.getString("AWS_SECRET_KEY");
        if (StringUtils.hasLength(this.AWS_ACCESS_KEY + this.AWS_SECRET_KEY)) {
            AWSCredentials credentials = new BasicAWSCredentials(this.AWS_ACCESS_KEY, this.AWS_SECRET_KEY);
            s3client = AmazonS3ClientBuilder.standard().withCredentials(new AWSStaticCredentialsProvider(credentials))
                    .withRegion(Regions.AP_NORTHEAST_2).build();
        } else {
            s3client = AmazonS3ClientBuilder.standard().withRegion(Regions.AP_NORTHEAST_2).build();
        }
        log.info("uploadFilePath : [{}]", systemUploadPath);
    }

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

            File file = new File(this.systemUploadPath + uploadPath, filename);
            if (!file.getParentFile().exists())
                file.getParentFile().mkdirs();
            ObjectMetadata metadata = new ObjectMetadata();
            metadata.setContentLength(multipartFile.getSize());
            if (type == UploadFileType.ORIGINAL) {

                FileCopyUtils.copy(multipartFile.getBytes(), file);
                // request = new PutObjectRequest(bucketName, uploadPath + "/" + filename,
                // multipartFile.getInputStream(),
                // metadata);

            } else {
                BufferedImage sourceImg = Thumbnails.of(multipartFile.getInputStream()).scale(1).asBufferedImage();
                if (sourceImg == null)
                    throw new BadRequestException("file", "error.file", "이미지 파일이 아닙니다.");

                if (type.getHeight() == 0) {
                    if (sourceImg.getWidth() > type.getWidth()) {
                        Thumbnails.of(sourceImg).width(type.getWidth()).asBufferedImage();
                    } else {
                        Thumbnails.of(sourceImg).scale(1).toFile(file);
                    }
                } else {
                    Thumbnails.of(sourceImg).size(type.getWidth(), type.getHeight()).crop(Positions.CENTER)
                            .keepAspectRatio(true).toFile(file);
                }
            }
            String url = "/files/" + uploadPath + "/" + filename;
            try {
                PutObjectRequest request = new PutObjectRequest(bucketName, url.substring(1), file);
                s3client.putObject(request);
            } catch (Exception e) {
                log.error(e.getMessage());
            } finally {
                FileUtils.delete(file);
            }
            return UploadFileInfo.of(originalFileName, url);
        } catch (IOException e) {
            log.info("{}", e);
            throw new BadRequestException("file", "error.file", e.getMessage());
        }
    }
}
