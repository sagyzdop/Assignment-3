-- update arman armanov's phone number
UPDATE users
SET phone_number = '+77773414141'
WHERE given_name = 'Arman' AND surname = 'Armanov';

SELECT user_id, given_name, surname, phone_number 
FROM users 
WHERE given_name = 'Arman' AND surname = 'Armanov';

-- adjust caregiver rates, add 0.3 if under 10, otherwise 10%
UPDATE caregiver 
SET hourly_rate = hourly_rate + 0.30 
WHERE hourly_rate < 10;

UPDATE caregiver 
SET hourly_rate = ROUND(hourly_rate * 1.10::numeric, 2) 
WHERE hourly_rate >= 10;

SELECT caregiver_user_id, caregiving_type, hourly_rate 
FROM caregiver 
ORDER BY caregiver_user_id;

-- delete all jobs posted by amina aminova
DELETE FROM job
WHERE member_user_id IN (
    SELECT m.member_user_id
    FROM member m 
    JOIN users u ON m.member_user_id = u.user_id
    WHERE u.given_name = 'Amina' AND u.surname = 'Aminova'
);

SELECT job_id, member_user_id, required_caregiving_type, other_requirements
FROM job 
ORDER BY job_id;

-- remove members living on kabanbay batyr street
DELETE FROM member 
WHERE member_user_id IN (
    SELECT member_user_id 
    FROM address 
    WHERE street ILIKE 'Kabanbay Batyr'
);

SELECT member_user_id, house_rules, dependent_description
FROM member 
ORDER BY member_user_id;

-- show names for accepted appointments
SELECT cu.given_name AS caregiver_first, 
       cu.surname AS caregiver_last,
       mu.given_name AS member_first, 
       mu.surname AS member_last,
       a.appointment_date, 
       a.work_hours
FROM appointment a
JOIN caregiver c ON a.caregiver_user_id = c.caregiver_user_id
JOIN users cu ON c.caregiver_user_id = cu.user_id
JOIN member m ON a.member_user_id = m.member_user_id
JOIN users mu ON m.member_user_id = mu.user_id
WHERE a.status = 'accepted'
ORDER BY a.appointment_date;

-- find jobs requiring soft-spoken caregivers
SELECT job_id, other_requirements 
FROM job 
WHERE other_requirements ILIKE '%soft-spoken%'
ORDER BY job_id;

-- get work hours for babysitter appointments
SELECT a.appointment_id, 
       a.work_hours, 
       c.caregiving_type,
       cu.given_name || ' ' || cu.surname AS caregiver_name,
       a.appointment_date
FROM appointment a
JOIN caregiver c ON a.caregiver_user_id = c.caregiver_user_id
JOIN users cu ON c.caregiver_user_id = cu.user_id
WHERE c.caregiving_type = 'Babysitter'
ORDER BY a.appointment_id;

-- astana members looking for elderly care with no pets rule
SELECT j.job_id, 
       mu.given_name, 
       mu.surname, 
       a.street, 
       u.city, 
       m.house_rules
FROM job j
JOIN member m ON j.member_user_id = m.member_user_id
JOIN users u ON m.member_user_id = u.user_id
LEFT JOIN address a ON m.member_user_id = a.member_user_id
JOIN users mu ON m.member_user_id = mu.user_id
WHERE j.required_caregiving_type ILIKE 'Elderly Care'
  AND (u.city ILIKE 'Astana' OR a.town ILIKE 'Astana')
  AND m.house_rules ILIKE '%No pets%';

-- count how many applied to each job
SELECT job_id, COUNT(*) AS applicant_count 
FROM job_application 
GROUP BY job_id 
ORDER BY job_id;

-- total work hours for accepted appointments
SELECT COALESCE(SUM(work_hours), 0) AS total_hours 
FROM appointment 
WHERE status = 'accepted';

-- average rate for caregivers with accepted appointments
SELECT AVG(c.hourly_rate) AS avg_hourly
FROM caregiver c
JOIN appointment a ON a.caregiver_user_id = c.caregiver_user_id
WHERE a.status = 'accepted';

-- caregivers earning above the average
SELECT c.caregiver_user_id, 
       u.given_name, 
       u.surname, 
       c.hourly_rate
FROM caregiver c
JOIN users u ON c.caregiver_user_id = u.user_id
WHERE c.hourly_rate > (
    SELECT AVG(c2.hourly_rate)
    FROM caregiver c2
    JOIN appointment a ON a.caregiver_user_id = c2.caregiver_user_id
    WHERE a.status = 'accepted'
)
ORDER BY c.hourly_rate DESC;

-- calculate total cost of accepted appointments
SELECT COALESCE(SUM(a.work_hours * c.hourly_rate), 0) AS total_cost
FROM appointment a
JOIN caregiver c ON a.caregiver_user_id = c.caregiver_user_id
WHERE a.status = 'accepted';

-- create view for job applicants with their info
CREATE OR REPLACE VIEW job_applicants AS
SELECT ja.job_id, 
       ja.date_applied, 
       u.user_id AS applicant_user_id, 
       u.given_name, 
       u.surname, 
       c.caregiving_type, 
       c.hourly_rate
FROM job_application ja
JOIN caregiver c ON ja.caregiver_user_id = c.caregiver_user_id
JOIN users u ON c.caregiver_user_id = u.user_id;

SELECT * 
FROM job_applicants 
ORDER BY job_id, applicant_user_id;
