-- ============================================================================
-- 1. UPDATE 3.1: Change phone of 'Arman Armanov' to '+77773414141'
-- ============================================================================
UPDATE users
SET phone_number = '+77773414141'
WHERE given_name = 'Arman' AND surname = 'Armanov';

-- Verify the update
SELECT user_id, given_name, surname, phone_number 
FROM users 
WHERE given_name = 'Arman' AND surname = 'Armanov';


-- ============================================================================
-- 2. UPDATE 3.2: Add $0.3 commission if < $10, else add 10%
-- ============================================================================
-- For caregivers with rate < 10
UPDATE caregiver 
SET hourly_rate = hourly_rate + 0.30 
WHERE hourly_rate < 10;

-- For caregivers with rate >= 10
UPDATE caregiver 
SET hourly_rate = ROUND(hourly_rate * 1.10::numeric, 2) 
WHERE hourly_rate >= 10;

-- View all updated rates
SELECT caregiver_user_id, caregiving_type, hourly_rate 
FROM caregiver 
ORDER BY caregiver_user_id;


-- ============================================================================
-- 3. DELETE 4.1: Delete jobs posted by 'Amina Aminova'
-- ============================================================================
DELETE FROM job
WHERE member_user_id IN (
    SELECT m.member_user_id
    FROM member m 
    JOIN users u ON m.member_user_id = u.user_id
    WHERE u.given_name = 'Amina' AND u.surname = 'Aminova'
);

-- View remaining jobs
SELECT job_id, member_user_id, required_caregiving_type, other_requirements
FROM job 
ORDER BY job_id;


-- ============================================================================
-- 4. DELETE 4.2: Delete members living on 'Kabanbay Batyr' street
-- ============================================================================
DELETE FROM member 
WHERE member_user_id IN (
    SELECT member_user_id 
    FROM address 
    WHERE street ILIKE 'Kabanbay Batyr'
);

-- View remaining members
SELECT member_user_id, house_rules, dependent_description
FROM member 
ORDER BY member_user_id;


-- ============================================================================
-- 5.1 SIMPLE QUERY: Caregiver and Member names for accepted appointments
-- ============================================================================
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


-- ============================================================================
-- 5.2 SIMPLE QUERY: Jobs with "soft-spoken" in requirements
-- ============================================================================
SELECT job_id, other_requirements 
FROM job 
WHERE other_requirements ILIKE '%soft-spoken%'
ORDER BY job_id;


-- ============================================================================
-- 5.3 SIMPLE QUERY: Work hours of all babysitter appointments
-- ============================================================================
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


-- ============================================================================
-- 5.4 SIMPLE QUERY: Members looking for Elderly Care in Astana with "No pets"
-- ============================================================================
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


-- ============================================================================
-- 6.1 COMPLEX QUERY: Count applicants per job (GROUP BY)
-- ============================================================================
SELECT job_id, COUNT(*) AS applicant_count 
FROM job_application 
GROUP BY job_id 
ORDER BY job_id;


-- ============================================================================
-- 6.2 COMPLEX QUERY: Total hours for accepted appointments (SUM)
-- ============================================================================
SELECT COALESCE(SUM(work_hours), 0) AS total_hours 
FROM appointment 
WHERE status = 'accepted';


-- ============================================================================
-- 6.3 COMPLEX QUERY: Average hourly rate of caregivers with accepted appointments (AVG)
-- ============================================================================
SELECT AVG(c.hourly_rate) AS avg_hourly
FROM caregiver c
JOIN appointment a ON a.caregiver_user_id = c.caregiver_user_id
WHERE a.status = 'accepted';


-- ============================================================================
-- 6.4 COMPLEX QUERY: Caregivers earning above average (subquery)
-- ============================================================================
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


-- ============================================================================
-- 7. DERIVED ATTRIBUTE: Total cost for accepted appointments
-- ============================================================================
SELECT COALESCE(SUM(a.work_hours * c.hourly_rate), 0) AS total_cost
FROM appointment a
JOIN caregiver c ON a.caregiver_user_id = c.caregiver_user_id
WHERE a.status = 'accepted';


-- ============================================================================
-- 8. VIEW CREATION: Job applicants with caregiver details
-- ============================================================================
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

-- Query the view
SELECT * 
FROM job_applicants 
ORDER BY job_id, applicant_user_id;
