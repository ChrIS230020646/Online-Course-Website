package hkmu.comp3820sef._820sef_project_s12992583.service;

import hkmu.comp3820sef._820sef_project_s12992583.dto.*;
import hkmu.comp3820sef._820sef_project_s12992583.model.*;
import hkmu.comp3820sef._820sef_project_s12992583.repository.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class PollService {
    private static final Logger log = LoggerFactory.getLogger(PollService.class);

    @Autowired private PollRepository pollRepository;
    @Autowired private PollResponseRepository pollResponseRepository;
    @Autowired private UserRepository userRepository;
    @Autowired private CommentRepository commentRepository;

    public PollDTO getPollViewData(Long pollId, String username) {

        Poll poll = pollRepository.findById(pollId)
                .orElseThrow(() -> new RuntimeException("Poll not found"));
        AppUser user = userRepository.findByUsername(username);


        PollDTO dto = new PollDTO();
        dto.setId(poll.getId());
        dto.setQuestion(poll.getQuestion());
        dto.setOptions(poll.getOptions());
        dto.setCourseId(poll.getCourse().getId());


        dto.setInstructor(isUserInstructor(poll, username));

        List<PollResponse> allResponses = pollResponseRepository.findByPoll(poll);
        int[] counts = new int[poll.getOptions().size()];
        for (PollResponse r : allResponses) {
            int idx = r.getSelectedOptionIndex();
            if (idx >= 0 && idx < counts.length) {
                counts[idx]++;
            }
        }
        dto.setVotes(counts);
        dto.setTotalVotes(allResponses.size());


        int choice = pollResponseRepository.findByUserAndPoll(user, poll)
                .map(PollResponse::getSelectedOptionIndex)
                .orElse(-1);
        dto.setUserChoice(choice);

        return dto;
    }
    public List<PollDTO> getPollDTOsByInstructor(AppUser instructor) {
        List<Poll> polls = pollRepository.findByCourseInstructor(instructor);

        return polls.stream().map(this::convertToDTO).collect(Collectors.toList());
    }
    public PollDTO convertToDTO(Poll poll) {
        PollDTO dto = new PollDTO();
        dto.setId(poll.getId());
        dto.setQuestion(poll.getQuestion());


        dto.setVotes(poll.getVotes());


        if (poll.getCourse() != null) {
            dto.setCourseId(poll.getCourse().getId());

            PollDTO courseInfo = new PollDTO();
            courseInfo.setTitle(poll.getCourse().getTitle());
            dto.setCourse(courseInfo.getCourse());
        }

        return dto;
    }
    @Transactional
    public void castVote(Long pollId, String username, int optionIndex) {
        Poll poll = pollRepository.findById(pollId).orElseThrow();
        AppUser user = userRepository.findByUsername(username);

        pollResponseRepository.deleteByUserAndPoll(user, poll);
        pollResponseRepository.flush();

        if (optionIndex >= 0 && optionIndex < poll.getOptions().size()) {
            PollResponse newResp = new PollResponse(user, poll, optionIndex);
            newResp.setSelectedOptionText(poll.getOptions().get(optionIndex));
            pollResponseRepository.save(newResp);
        }
    }

    @Transactional
    public boolean deletePoll(Long pollId, String username) {
        Poll poll = pollRepository.findById(pollId).orElseThrow();
        if (isUserInstructor(poll, username)) {
            pollResponseRepository.deleteByPoll(poll);
            pollRepository.delete(poll);
            return true;
        }
        return false;
    }

    @Transactional
    public void updateQuestion(Long pollId, String username, String newQuestion) {
        Poll poll = pollRepository.findById(pollId).orElseThrow();
        if (isUserInstructor(poll, username)) {
            poll.setQuestion(newQuestion);
            pollRepository.save(poll);
        }
    }

    @Transactional
    public boolean updateOption(Long pollId, String username, int index, String text) {
        Poll poll = pollRepository.findById(pollId).orElseThrow();
        if (isUserInstructor(poll, username) && index >= 0 && index < poll.getOptions().size()) {
            poll.getOptions().set(index, text);
            pollRepository.save(poll);
            return true;
        }
        return false;
    }


    private boolean isUserInstructor(Poll poll, String username) {
        return poll.getCourse() != null &&
                poll.getCourse().getInstructor() != null &&
                poll.getCourse().getInstructor().getUsername().equalsIgnoreCase(username);
    }



@Transactional(readOnly = true)
public List<PollGroupDTO> getAllPollHistory() {
    List<Poll> polls = pollRepository.findAll();
    List<PollGroupDTO> pollHistories = new ArrayList<>();

    for (Poll poll : polls) {
        PollGroupDTO groupDto = new PollGroupDTO();
        groupDto.setPollId(poll.getId());
        groupDto.setPollQuestion(poll.getQuestion());



        if (poll.getCourse() != null) {
            groupDto.setCourseId(poll.getCourse().getId().toString());
            groupDto.setCreatedBy(poll.getCourse().getInstructor() != null ? poll.getCourse().getInstructor().getUsername():"null");
        } else {
            groupDto.setCourseId("N/A");
        }

        groupDto.setPollQuestion(poll.getQuestion());
        List<PollResponse> responses = pollResponseRepository.findByPoll(poll);
        List<VoterDetail> voterDetails = new ArrayList<>();
        if (responses != null) {
            for (PollResponse r : responses) {
                VoterDetail vd = new VoterDetail();
                vd.setUsername(r.getUser().getUsername());
                vd.setOptionText(r.getSelectedOptionText());
                voterDetails.add(vd);
            }
        }
        groupDto.setVoters(voterDetails);
        pollHistories.add(groupDto);
    }
    return pollHistories;
}

    public PollDTO getJustResults(Long pollId) {
        Poll poll = pollRepository.findById(pollId)
                .orElseThrow(() -> new RuntimeException("Poll not found"));

        PollDTO dto = new PollDTO();
        dto.setQuestion(poll.getQuestion());
        dto.setOptions(poll.getOptions());


        List<PollResponse> responses = pollResponseRepository.findByPoll(poll);
        int[] counts = new int[poll.getOptions().size()];
        for (PollResponse r : responses) {
            int idx = r.getSelectedOptionIndex();
            if (idx >= 0 && idx < counts.length) counts[idx]++;
        }
        dto.setVotes(counts);
        dto.setTotalVotes(responses.size());

        return dto;
    }


}