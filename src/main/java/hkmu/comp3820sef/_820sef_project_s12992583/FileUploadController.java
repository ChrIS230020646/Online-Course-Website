package hkmu.comp3820sef._820sef_project_s12992583;

import hkmu.comp3820sef._820sef_project_s12992583.model.FileEntity;
import hkmu.comp3820sef._820sef_project_s12992583.repository.FileRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.http.ResponseEntity;
import java.io.IOException;

@RestController
@RequestMapping("/files")
public class FileUploadController {

    @Autowired
    private FileRepository fileRepository;

    @PostMapping("/upload")
    public ResponseEntity<String> uploadFile(@RequestParam("file") MultipartFile file) {
        try {
            FileEntity fileEntity = new FileEntity(
                    file.getOriginalFilename(),
                    file.getContentType(),
                    file.getBytes()
            );

            fileRepository.save(fileEntity);
            return ResponseEntity.ok("file success: " + file.getOriginalFilename());

        } catch (IOException e) {
            return ResponseEntity.status(500).body("file not success");
        }
    }
}