package hkmu.comp3820sef._820sef_project_s12992583;


import hkmu.comp3820sef._820sef_project_s12992583.model.AppUser;
import hkmu.comp3820sef._820sef_project_s12992583.model.Comment;
import hkmu.comp3820sef._820sef_project_s12992583.model.Lecture;
import hkmu.comp3820sef._820sef_project_s12992583.repository.CommentRepository;

import hkmu.comp3820sef._820sef_project_s12992583.repository.CourseRepository;
import hkmu.comp3820sef._820sef_project_s12992583.repository.LectureRepository;
import hkmu.comp3820sef._820sef_project_s12992583.repository.UserRepository;
import jakarta.servlet.http.HttpServletRequest;
import org.apache.tomcat.util.net.openssl.ciphers.Authentication;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.util.List;


@Controller
@RequestMapping("/comment")
public class CommentController {

    @Autowired
    private CommentRepository commentRepository;
    @Autowired
    private UserRepository userRepository;
    @Autowired
    private LectureRepository lectureRepository;

//    @GetMapping("/lectures/{lectureId}")
//    public String viewLecture(@PathVariable Long lectureId, Model model) {
//        // 1. 抓取 Lecture 基本資料
//        Lecture lecture = lectureRepository.findById(lectureId)
//                .orElseThrow(() -> new IllegalArgumentException("Lecture not found"));
//
//        // 2. 關鍵：手動去 CommentRepository 抓取屬於這堂課的評論
//        // 只抓 parent_id 為空的（主評論），回覆會由 JPA 的 @OneToMany 自動抓取
//        List<Comment> comments = commentRepository.findByLectureIdAndParentCommentIsNullOrderByCommentTimeDesc(lectureId);
//        List<Comment> commentList =commentRepository.findByLecture(lecture);
//        // 3. 將數據交給 JSP
//        model.addAttribute("lecture", lecture);
//        model.addAttribute("comments", comments); // JSP 將使用這個變數
//        model.addAttribute("commentList", commentList); // JSP 將使用這個變數
//        model.addAttribute("lectureId", lectureId);
//
//        return "lecture-detail"; // 或者是你的 JSP 檔名
//    }
@GetMapping("/history")
public String showHistory(@RequestParam(value = "lectureId", required = false) Long lectureId, // 接收選填的 lectureId
        @RequestParam(value = "sortBy", defaultValue = "commentTime") String sortBy,
        @RequestParam(value = "dir", defaultValue = "desc") String dir,
        Principal principal, Model model) {
    AppUser currentUser = userRepository.findByUsername(principal.getName());
    Sort sort = dir.equalsIgnoreCase("asc") ? Sort.by(sortBy).ascending() : Sort.by(sortBy).descending();

    List<Comment> historyList = commentRepository.findByUser(currentUser, sort);

    // 強行觸發 Hibernate 加載關聯資料，避免 JSP 讀不到
    for (Comment cmt : historyList) {
        if (cmt.getLecture() != null) {
            cmt.getLecture().getTitle(); // 觸發 Proxy 加載
        }
        if (cmt.getParentComment() != null) {
            cmt.getParentComment().getDescription(); // 如果有回覆內容也要加載
        }
    }

    model.addAttribute("historyList", historyList);
    return "comment-history";
}
//@GetMapping("/history")
//public String showCommentHistory(
////        @RequestParam(value = "lectureId", required = false) Long lectureId, // 接收選填的 lectureId
//        @RequestParam(value = "sortBy", defaultValue = "commentTime") String sortBy,
//        @RequestParam(value = "dir", defaultValue = "desc") String dir,
//        Principal principal, Model model) {
//
//    if (principal == null) return "redirect:/login";
//
//    AppUser currentUser = userRepository.findByUsername(principal.getName());
//    Sort sort = dir.equalsIgnoreCase("asc") ? Sort.by(sortBy).ascending() : Sort.by(sortBy).descending();
//
//    List<Comment> historyList;
//
//
//        // 否則搵晒所有課程嘅留言
//        historyList = commentRepository.findByUser(currentUser, sort);
//
//
////    model.addAttribute("historyList", historyList);
//
//    model.addAttribute("historyList", historyList);
//    return "comment-history";
//}

    @PostMapping("/delete/{id}")
    public String deleteComment(@PathVariable Long id,
                                HttpServletRequest request) {

        // 執行刪除
        commentRepository.deleteById(id);

        // 獲取發送請求的來源網址 (Referer)
        String referer = request.getHeader("Referer");

        // 如果抓得到來源網址，就跳回去；抓不到則跳回首頁
        return "redirect:" + (referer != null ? referer : "/");
    }
    // 處理新增評論
    @PostMapping("/lectures/{lectureId}/add-comment")
    public String addComment(@PathVariable Long lectureId,
                             @RequestParam String description,
                             @RequestParam(required = false) Long parentId,
                             Principal principal) {

        if (principal == null) return "redirect:/login";

        String username = principal.getName();
        AppUser currentUser = userRepository.findByUsername(username);

        Lecture lecture = lectureRepository.findById(lectureId)
                .orElseThrow(() -> new IllegalArgumentException("Invalid lecture Id:" + lectureId));

        Comment comment = new Comment();
        comment.setDescription(description);
        comment.setUser(currentUser);
        comment.setLecture(lecture);
        // 設定時間（如果有需要顯示的話）
        // comment.setCommentTime(new LocalDateTime());

        if (parentId != null) {
            commentRepository.findById(parentId).ifPresent(comment::setParentComment);
        }

        commentRepository.save(comment);

        // 重導向到顯示課程的頁面，請確保這個路徑存在！
        return "redirect:/course-material-page/" + lectureId;
    }


    // 處理老師刪除評論
    @PostMapping("/lectures/delete/{id}")
    public String deleteComment(@PathVariable Long id,
                                @RequestParam Long lectureId,
                                Principal principal)  {

        Comment comment = commentRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Invalid comment Id:" + id));

        // 權限檢查：必須是老師，或者是該留言的擁有者
        String currentUsername = principal.getName();
        boolean isTeacher = userRepository.findByUsername(currentUsername).getRole().equals("teacher");//role
        boolean isOwner = comment.getUser().getUsername().equals(currentUsername);

        if (isTeacher || isOwner) {
            commentRepository.delete(comment);
        }

        return "redirect:/course-material-page/" + lectureId;
    }
    @GetMapping("/comments/{Id}")
    public String getCommentById(@PathVariable Long Id, Model model) {
        // 1. 根據 ID 抓取單一條評論
        Comment comment = commentRepository.findById(Id)
                .orElseThrow(() -> new IllegalArgumentException("Comment ID " + Id + " not found"));

        // 2. 將這條評論的資訊放入 Model
        model.addAttribute("cmt", comment);

        // 3. 為了讓返回按鈕能運作，通常也會傳入所屬的 lectureId
        model.addAttribute("lectureId", comment.getLecture().getId());

        // 返回你指定的 JSP 組件名稱
        return "components/Comment-ComponentById";
    }
//@GetMapping("/comments/{Id}")
//public String getCommentById(@PathVariable Long Id, Model model) {
//    // Use findById and handle the absence gracefully
//    return commentRepository.findById(Id).map(comment -> {
//        model.addAttribute("cmt", comment);
//        model.addAttribute("lectureId", comment.getLecture().getId());
//        return "components/Comment-ComponentById";
//    }
//    )
//            .orElseGet(() -> {
//        // Log the error and redirect or return an error view instead of crashing
//        model.addAttribute("errorMessage", "Comment not found.");
//        return "redirect:/courses";
//    });
//}


}