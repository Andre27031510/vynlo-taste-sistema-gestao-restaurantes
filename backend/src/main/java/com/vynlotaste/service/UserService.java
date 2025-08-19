package com.vynlotaste.service;

import com.vynlotaste.dto.UserRegistrationDto;
import com.vynlotaste.entity.User;
import com.vynlotaste.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

@Slf4j
@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;

    @Transactional
    public User createUserFromFirebase(String email, String name) {
        log.info("Criando usuário Firebase: email={}, name={}", email, name);
        
        User user = new User();
        user.setEmail(email);
        user.setUsername(email);
        user.setFirstName(name != null ? name.split(" ")[0] : "");
        user.setLastName(name != null && name.split(" ").length > 1 ? name.split(" ")[1] : "");
        user.setRole(User.UserRole.CUSTOMER);
        user.setActive(true);
        user.setCreatedAt(LocalDateTime.now());
        user.setUpdatedAt(LocalDateTime.now());
        
        User savedUser = userRepository.save(user);
        log.info("Usuário Firebase criado com sucesso: id={}, email={}", savedUser.getId(), savedUser.getEmail());
        
        return savedUser;
    }

    @Transactional
    public User createUserFromRegistration(UserRegistrationDto registrationDto) {
        log.info("Criando usuário por registro: email={}, username={}", 
                registrationDto.getEmail(), registrationDto.getUsername());
        
        User user = new User();
        user.setEmail(registrationDto.getEmail());
        user.setUsername(registrationDto.getUsername());
        user.setFirstName(registrationDto.getFirstName());
        user.setLastName(registrationDto.getLastName());
        user.setPhone(registrationDto.getPhone());
        user.setAddress(registrationDto.getAddress());
        user.setCpf(registrationDto.getCpf());
        user.setRole(User.UserRole.CUSTOMER);
        user.setActive(true);
        user.setCreatedAt(LocalDateTime.now());
        user.setUpdatedAt(LocalDateTime.now());
        
        User savedUser = userRepository.save(user);
        log.info("Usuário registrado com sucesso: id={}, email={}", savedUser.getId(), savedUser.getEmail());
        
        return savedUser;
    }

    public boolean isEmailAvailable(String email) {
        return !userRepository.findByEmail(email).isPresent();
    }

    public boolean isUsernameAvailable(String username) {
        return !userRepository.findByUsername(username).isPresent();
    }
}
