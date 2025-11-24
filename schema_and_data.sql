DROP VIEW IF EXISTS job_applicants;
DROP TABLE IF EXISTS job_application;
DROP TABLE IF EXISTS appointment;
DROP TABLE IF EXISTS job;
DROP TABLE IF EXISTS address;
DROP TABLE IF EXISTS caregiver;
DROP TABLE IF EXISTS member;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    given_name VARCHAR(100) NOT NULL,
    surname VARCHAR(100) NOT NULL,
    city VARCHAR(100),
    phone_number VARCHAR(50),
    profile_description TEXT,
    password VARCHAR(255) NOT NULL
);

CREATE TABLE caregiver (
    caregiver_user_id INT PRIMARY KEY REFERENCES users(user_id) ON DELETE CASCADE,
    photo VARCHAR(255),
    gender VARCHAR(20),
    caregiving_type VARCHAR(100),
    hourly_rate NUMERIC(8,2) NOT NULL
);

CREATE TABLE member (
    member_user_id INT PRIMARY KEY REFERENCES users(user_id) ON DELETE CASCADE,
    house_rules TEXT,
    dependent_description TEXT
);

CREATE TABLE address (
    member_user_id INT PRIMARY KEY REFERENCES member(member_user_id) ON DELETE CASCADE,
    house_number VARCHAR(20),
    street VARCHAR(255),
    town VARCHAR(100)
);

CREATE TABLE job (
    job_id SERIAL PRIMARY KEY,
    member_user_id INT REFERENCES member(member_user_id) ON DELETE CASCADE,
    required_caregiving_type VARCHAR(100),
    other_requirements TEXT,
    date_posted DATE NOT NULL
);

CREATE TABLE job_application (
    caregiver_user_id INT REFERENCES caregiver(caregiver_user_id) ON DELETE CASCADE,
    job_id INT REFERENCES job(job_id) ON DELETE CASCADE,
    date_applied DATE NOT NULL,
    PRIMARY KEY (caregiver_user_id, job_id)
);

CREATE TABLE appointment (
    appointment_id SERIAL PRIMARY KEY,
    caregiver_user_id INT REFERENCES caregiver(caregiver_user_id) ON DELETE CASCADE,
    member_user_id INT REFERENCES member(member_user_id) ON DELETE CASCADE,
    appointment_date DATE NOT NULL,
    appointment_time TIME NOT NULL,
    work_hours NUMERIC(6,2) NOT NULL,
    status VARCHAR(50) NOT NULL
);

INSERT INTO users (email, given_name, surname, city, phone_number, profile_description, password) VALUES
 ('arman.armanov@example.com', 'Arman', 'Armanov', 'Astana', '+77001234567', 'Experienced caregiver for elderly clients.', 'pass1'),
 ('amina.aminova@example.com', 'Amina', 'Aminova', 'Almaty', '+77007654321', 'Looking for part-time caregiver roles.', 'pass2'),
 ('bekzat.s@example.com', 'Bekzat', 'Suleimenov', 'Astana', '+77001112233', 'Reliable babysitter and tutor.', 'pass3'),
 ('gulnara.g@example.com', 'Gulnara', 'Gabitova', 'Shymkent', '+77004445566', 'Compassionate elderly-care specialist.', 'pass4'),
 ('nurzhan.n@example.com', 'Nurzhan', 'Nuraliev', 'Astana', '+77005556677', 'Nightshift caregiver available.', 'pass5'),
 ('aliya.a@example.com', 'Aliya', 'Akhmetova', 'Astana', '+77006667788', 'Baby-sitting and light housekeeping.', 'pass6'),
 ('serik.s@example.com', 'Serik', 'Sadykov', 'Karaganda', '+77007778899', 'Experienced with special needs dependents.', 'pass7'),
 ('zhanar.z@example.com', 'Zhanar', 'Zhaksylyk', 'Astana', '+77008889900', 'Seeking daytime help for toddler.', 'pass8'),
 ('diana.d@example.com', 'Diana', 'Dosanova', 'Almaty', '+77009990011', 'Looking after elderly mother.', 'pass9'),
 ('olzhas.o@example.com', 'Olzhas', 'Ospanov', 'Astana', '+77010011000', 'Flexible caregiver.', 'pass10'),
 ('madina.m@example.com', 'Madina', 'Muratova', 'Astana', '+77012013014', 'No pets at home.', 'pass11'),
 ('yerbol.y@example.com', 'Yerbol', 'Yessimov', 'Astana', '+77014015016', 'Part-time elder care.', 'pass12');

INSERT INTO caregiver (caregiver_user_id, photo, gender, caregiving_type, hourly_rate) VALUES
 (1, 'arman.jpg', 'male', 'Elderly Care', 12.00),
 (3, 'bekzat.jpg', 'male', 'Babysitter', 9.50),
 (4, 'gulnara.jpg', 'female', 'Elderly Care', 15.00),
 (5, 'nurzhan.jpg', 'male', 'Night Care', 8.50),
 (6, 'aliya.jpg', 'female', 'Babysitter', 11.00),
 (7, 'serik.jpg', 'male', 'Special Needs', 13.00);

INSERT INTO users (email, given_name, surname, city, phone_number, profile_description, password) VALUES
 ('aigerim.k@example.com', 'Aigerim', 'Kenzheeva', 'Astana', '+77016017018', 'Senior care specialist.', 'pass13'),
 ('timur.t@example.com', 'Timur', 'Temirkhanov', 'Almaty', '+77018019020', 'Experienced with infants.', 'pass14'),
 ('saule.s@example.com', 'Saule', 'Samatova', 'Shymkent', '+77020021022', 'Physical therapy background.', 'pass15'),
 ('azamat.a@example.com', 'Azamat', 'Aitzhanov', 'Astana', '+77022023024', 'Weekend availability.', 'pass16');

INSERT INTO caregiver (caregiver_user_id, photo, gender, caregiving_type, hourly_rate) VALUES
 (13, 'aigerim.jpg', 'female', 'Elderly Care', 14.50),
 (14, 'timur.jpg', 'male', 'Babysitter', 10.00),
 (15, 'saule.jpg', 'female', 'Special Needs', 16.00),
 (16, 'azamat.jpg', 'male', 'Babysitter', 9.00);

INSERT INTO member (member_user_id, house_rules, dependent_description) VALUES
 (2, 'No smoking; No pets', 'Requires part-time help for an elderly parent.'),
 (8, 'No pets', 'Toddler, 2 years old.'),
 (9, 'No smoking', 'Elderly mother with mobility issues.'),
 (10, 'No pets; Quiet hours after 10pm', 'Recovering from surgery.'),
 (11, 'No pets', 'Senior with dementia.'),
 (12, 'No shoes indoors; No pets', 'Elderly, needs weekly visits.');

INSERT INTO users (email, given_name, surname, city, phone_number, profile_description, password) VALUES
 ('dana.d@example.com', 'Dana', 'Dauletova', 'Almaty', '+77024025026', 'Two children, ages 5 and 7.', 'pass17'),
 ('ruslan.r@example.com', 'Ruslan', 'Rakhimov', 'Astana', '+77026027028', 'Elderly father with Alzheimers.', 'pass18'),
 ('gaukhar.g@example.com', 'Gaukhar', 'Galieva', 'Karaganda', '+77028029030', 'Newborn, first-time parent.', 'pass19'),
 ('askar.a@example.com', 'Askar', 'Aldabergenov', 'Astana', '+77030031032', 'Disabled brother needs care.', 'pass20');

INSERT INTO member (member_user_id, house_rules, dependent_description) VALUES
 (17, 'No smoking', 'Two school-age children.'),
 (18, 'Quiet environment; No pets', 'Father with Alzheimers disease.'),
 (19, 'Pets allowed', 'Newborn baby, 3 months old.'),
 (20, 'Wheelchair accessible', 'Brother with mobility impairment.');

INSERT INTO address (member_user_id, house_number, street, town) VALUES
 (2, '12', 'Kabanbay Batyr', 'Almaty'),
 (8, '45', 'Azattyq', 'Astana'),
 (9, '7', 'Al-Farabi', 'Almaty'),
 (10, '101', 'Kabanbay Batyr', 'Astana'),
 (11, '20', 'Dostyk', 'Astana'),
 (12, '3', 'Saryarka', 'Astana'),
 (17, '88', 'Abay', 'Almaty'),
 (18, '15', 'Mangilik El', 'Astana'),
 (19, '42', 'Seifullin', 'Karaganda'),
 (20, '9', 'Respublika', 'Astana');

INSERT INTO job (member_user_id, required_caregiving_type, other_requirements, date_posted) VALUES
 (2, 'Elderly Care', 'Soft-spoken preferred; experience with diabetes', '2025-09-01'),
 (8, 'Babysitter', 'Evening hours; CPR certified', '2025-09-05'),
 (9, 'Elderly Care', 'No heavy lifting; patient required', '2025-09-10'),
 (2, 'Night Care', 'Night shifts; light housekeeping', '2025-09-12'),
 (10, 'Post-Op Care', 'Short-term; medication administration', '2025-09-15'),
 (11, 'Elderly Care', 'Soft-spoken; experience with dementia', '2025-09-18'),
 (12, 'Elderly Care', 'Weekly visits; companionship', '2025-09-20'),
 (8, 'Babysitter', 'Weekend mornings', '2025-09-22'),
 (2, 'Special Needs', 'Motor-skill assistance', '2025-09-25'),
 (8, 'Babysitter', 'No pets; fun with kids', '2025-09-28'),
 (9, 'Elderly Care', 'Soft-spoken and patient', '2025-09-30'),
 (10, 'Night Care', 'Overnight care needed', '2025-10-01');

INSERT INTO job_application (caregiver_user_id, job_id, date_applied) VALUES
 (1, 1, '2025-09-02'),
 (3, 2, '2025-09-06'),
 (4, 1, '2025-09-03'),
 (5, 4, '2025-09-13'),
 (6, 2, '2025-09-07'),
 (7, 9, '2025-09-26'),
 (3, 8, '2025-09-23'),
 (6, 10, '2025-09-29'),
 (1, 3, '2025-09-11'),
 (4, 6, '2025-09-19'),
 (7, 7, '2025-09-21');

INSERT INTO appointment (caregiver_user_id, member_user_id, appointment_date, appointment_time, work_hours, status) VALUES
 (1, 2, '2025-10-01', '09:00', 4.00, 'accepted'),
 (3, 8, '2025-10-03', '18:00', 3.50, 'accepted'),
 (4, 9, '2025-10-05', '14:00', 5.00, 'pending'),
 (5, 2, '2025-10-07', '22:00', 8.00, 'accepted'),
 (6, 8, '2025-10-09', '10:00', 2.50, 'rejected'),
 (1, 11, '2025-10-11', '09:00', 6.00, 'accepted'),
 (4, 12, '2025-10-13', '08:00', 3.00, 'accepted'),
 (3, 10, '2025-10-15', '16:00', 2.00, 'accepted'),
 (13, 17, '2025-10-17', '15:00', 4.50, 'accepted'),
 (14, 19, '2025-10-19', '12:00', 3.00, 'pending');

CREATE OR REPLACE VIEW job_applicants AS
SELECT ja.job_id, ja.date_applied, u.user_id AS applicant_user_id, u.given_name, u.surname, c.caregiving_type, c.hourly_rate
FROM job_application ja
JOIN caregiver c ON ja.caregiver_user_id = c.caregiver_user_id
JOIN users u ON c.caregiver_user_id = u.user_id;
