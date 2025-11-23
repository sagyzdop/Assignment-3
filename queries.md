# Part 2 Query Results Showcase
## CSCI 341 Assignment 3 - Database Operations

This document showcases all 14 required queries with their outputs and explanations.

---

## UPDATE OPERATIONS

### 3.1: Update Phone Number ✅
**Task:** Change Arman Armanov's phone to +77773414141

**Query:**
```sql
UPDATE users
SET phone_number = '+77773414141'
WHERE given_name = 'Arman' AND surname = 'Armanov'
```

**Result:**
```
{'user_id': 1, 'given_name': 'Arman', 'surname': 'Armanov', 'phone_number': '+77773414141'}
```
✅ Successfully updated Arman's phone number.

---

### 3.2: Update Hourly Rates with Commission ✅
**Task:** Add $0.30 if rate < $10, else add 10%

**Queries:**
```sql
-- For rates under $10
UPDATE caregiver SET hourly_rate = hourly_rate + 0.30 WHERE hourly_rate < 10

-- For rates $10 and above
UPDATE caregiver SET hourly_rate = ROUND(hourly_rate * 1.10, 2) WHERE hourly_rate >= 10
```

**Results:**
```
Bekzat (Babysitter): $9.50 → $9.80
Nurzhan (Night Care): $8.50 → $8.80
Arman (Elderly Care): $12.00 → $13.20 (+10%)
Gulnara (Elderly Care): $15.00 → $16.50 (+10%)
Aliya (Babysitter): $11.00 → $12.10 (+10%)
Serik (Special Needs): $13.00 → $14.30 (+10%)
```
✅ Commission logic applied correctly.

---

## DELETE OPERATIONS

### 4.1: Delete Jobs by Amina Aminova ✅
**Task:** Remove all jobs posted by member Amina Aminova

**Query:**
```sql
DELETE FROM job
WHERE member_user_id IN (
    SELECT m.member_user_id
    FROM member m JOIN users u ON m.member_user_id = u.user_id
    WHERE u.given_name = 'Amina' AND u.surname = 'Aminova'
)
```

**Result:**
- Jobs deleted: 3 (job_ids: 1, 4, 9)
- Remaining jobs: 9
✅ Cascade deletes also removed related job applications.

---

### 4.2: Delete Members on Kabanbay Batyr Street ✅
**Task:** Remove members living on 'Kabanbay Batyr' street

**Query:**
```sql
DELETE FROM member 
WHERE member_user_id IN (
    SELECT member_user_id FROM address WHERE street ILIKE 'Kabanbay Batyr'
)
```

**Result:**
- Deleted member_user_ids: [2, 10]
- Remaining members: 4
✅ Cascade deletes removed related addresses, jobs, and appointments.

---

## SIMPLE QUERIES

### 5.1: Accepted Appointments with Names ✅
**Task:** Show caregiver and member names for accepted appointments

**Query:**
```sql
SELECT cu.given_name AS caregiver_first, cu.surname AS caregiver_last,
       mu.given_name AS member_first, mu.surname AS member_last,
       a.appointment_date, a.work_hours
FROM appointment a
JOIN caregiver c ON a.caregiver_user_id = c.caregiver_user_id
JOIN users cu ON c.caregiver_user_id = cu.user_id
JOIN member m ON a.member_user_id = m.member_user_id
JOIN users mu ON m.member_user_id = mu.user_id
WHERE a.status = 'accepted'
ORDER BY a.appointment_date
```

**Results:**
```
Bekzat Suleimenov → Zhanar Zhaksylyk | 2025-10-03 | 3.5 hours
Arman Armanov → Madina Muratova      | 2025-10-11 | 6.0 hours
Gulnara Gabitova → Yerbol Yessimov   | 2025-10-13 | 3.0 hours
```
✅ 3 accepted appointments found with complete names.

---

### 5.2: Jobs with "Soft-Spoken" Requirement ✅
**Task:** List job_ids with 'soft-spoken' in requirements

**Query:**
```sql
SELECT job_id, other_requirements 
FROM job 
WHERE other_requirements ILIKE '%soft-spoken%'
```

**Results:**
```
job_id: 6 | "Soft-spoken; experience with dementia"
job_id: 11 | "Soft-spoken and patient"
```
✅ 2 jobs require soft-spoken caregivers.

---

### 5.3: Babysitter Work Hours ✅
**Task:** Work hours of all babysitter positions

**Query:**
```sql
SELECT a.appointment_id, a.work_hours, c.caregiving_type,
       cu.given_name || ' ' || cu.surname AS caregiver_name,
       a.appointment_date
FROM appointment a
JOIN caregiver c ON a.caregiver_user_id = c.caregiver_user_id
JOIN users cu ON c.caregiver_user_id = cu.user_id
WHERE c.caregiving_type = 'Babysitter'
ORDER BY a.appointment_id
```

**Results:**
```
Appointment 1: Aliya Akhmetova | 1.0 hours | 2025-10-01
Appointment 2: Bekzat Suleimenov | 3.5 hours | 2025-10-03
Appointment 5: Aliya Akhmetova | 2.5 hours | 2025-10-09
```
✅ Total: 7.0 hours of babysitter appointments.

---

### 5.4: Elderly Care in Astana with No Pets ✅
**Task:** Members looking for Elderly Care in Astana with 'No pets' rule

**Query:**
```sql
SELECT j.job_id, mu.given_name, mu.surname, a.street, u.city, m.house_rules
FROM job j
JOIN member m ON j.member_user_id = m.member_user_id
JOIN users u ON m.member_user_id = u.user_id
LEFT JOIN address a ON m.member_user_id = a.member_user_id
JOIN users mu ON m.member_user_id = mu.user_id
WHERE j.required_caregiving_type ILIKE 'Elderly Care'
  AND (u.city ILIKE 'Astana' OR a.town ILIKE 'Astana')
  AND m.house_rules ILIKE '%No pets%'
```

**Results:**
```
Job 6: Madina Muratova | Dostyk, Astana | "No pets"
Job 7: Yerbol Yessimov | Saryarka, Astana | "No shoes indoors; No pets"
```
✅ 2 matching jobs found.

---

## COMPLEX QUERIES WITH AGGREGATIONS

### 6.1: Count Applicants Per Job ✅
**Task:** Use GROUP BY to count applicants per job

**Query:**
```sql
SELECT job_id, COUNT(*) AS applicant_count 
FROM job_application 
GROUP BY job_id 
ORDER BY job_id
```

**Results:**
```
Job 2: 2 applicants
Job 3: 1 applicant
Job 6: 1 applicant
Job 7: 1 applicant
Job 8: 1 applicant
Job 10: 1 applicant
```
✅ Total: 7 applications across 6 jobs.

---

### 6.2: Total Hours for Accepted Appointments ✅
**Task:** Sum of work hours for accepted appointments

**Query:**
```sql
SELECT COALESCE(SUM(work_hours), 0) AS total_hours 
FROM appointment 
WHERE status = 'accepted'
```

**Result:**
```
Total hours: 12.5
```
✅ Correct sum of 3.5 + 6.0 + 3.0 = 12.5 hours.

---

### 6.3: Average Hourly Rate ✅
**Task:** Average pay of caregivers with accepted appointments

**Query:**
```sql
SELECT AVG(c.hourly_rate) AS avg_hourly
FROM caregiver c
JOIN appointment a ON a.caregiver_user_id = c.caregiver_user_id
WHERE a.status = 'accepted'
```

**Result:**
```
Average hourly rate: $13.17
```
✅ Average of $9.80, $13.20, and $16.50.

---

### 6.4: Caregivers Above Average ✅
**Task:** Find caregivers earning above the average rate

**Query:**
```sql
-- First calculate average
SELECT AVG(c.hourly_rate) FROM caregiver c ...

-- Then find caregivers above it
SELECT c.caregiver_user_id, u.given_name, u.surname, c.hourly_rate
FROM caregiver c
JOIN users u ON c.caregiver_user_id = u.user_id
WHERE c.hourly_rate > 13.17
```

**Results:**
```
Arman Armanov: $13.20 (above average)
Gulnara Gabitova: $16.50 (above average)
Serik Sadykov: $14.30 (above average)
```
✅ 3 caregivers earn above average.

---

## DERIVED ATTRIBUTE

### 7: Total Cost of Accepted Appointments ✅
**Task:** Calculate total cost (work_hours × hourly_rate)

**Query:**
```sql
SELECT COALESCE(SUM(a.work_hours * c.hourly_rate), 0) AS total_cost
FROM appointment a
JOIN caregiver c ON a.caregiver_user_id = c.caregiver_user_id
WHERE a.status = 'accepted'
```

**Calculation:**
```
Bekzat (3.5 hrs × $9.80)  = $34.30
Arman (6.0 hrs × $13.20)  = $79.20
Gulnara (3.0 hrs × $16.50) = $49.50
--------------------------------
Total Cost: $163.00
```
✅ Derived attribute calculated correctly.

---

## VIEW OPERATION

### 8: Job Applications View ✅
**Task:** Create and query a view of job applications with applicant info

**Query:**
```sql
CREATE OR REPLACE VIEW job_applicants AS
SELECT ja.job_id, ja.date_applied, u.user_id AS applicant_user_id, 
       u.given_name, u.surname, c.caregiving_type, c.hourly_rate
FROM job_application ja
JOIN caregiver c ON ja.caregiver_user_id = c.caregiver_user_id
JOIN users u ON c.caregiver_user_id = u.user_id

-- Query the view
SELECT * FROM job_applicants ORDER BY job_id, applicant_user_id
```

**Results:**
```
7 rows showing job applications with:
- Job ID and application date
- Applicant name and ID
- Caregiver type and hourly rate
```
✅ View created successfully and returns joined data.

