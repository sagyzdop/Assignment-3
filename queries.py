from sqlalchemy import create_engine, text

DATABASE_URL = 'postgresql://postgres:postgres@localhost:5432/caregivers_db'
engine = create_engine(DATABASE_URL)

def run():
    with engine.begin() as conn:
        print('Connected to DB')

        print('\n1) Update 3.1: Update Arman Armanov phone')
        conn.execute(text("""
            UPDATE users
            SET phone_number = :new_phone
            WHERE given_name = 'Arman' AND surname = 'Armanov'
        """), {'new_phone': '+77773414141'})
        res = conn.execute(text("SELECT user_id, given_name, surname, phone_number FROM users WHERE given_name='Arman' AND surname='Armanov'"))
        for row in res:
            print(row._asdict())

        print('\n2) Update 3.2: Adjust caregiver hourly_rate by commission/percentage')
        conn.execute(text("UPDATE caregiver SET hourly_rate = hourly_rate + 0.30 WHERE hourly_rate < 10"))
        conn.execute(text("UPDATE caregiver SET hourly_rate = ROUND(hourly_rate * 1.10::numeric, 2) WHERE hourly_rate >= 10"))
        for row in conn.execute(text('SELECT caregiver_user_id, caregiving_type, hourly_rate FROM caregiver')):
            print(row._asdict())

        print('\n3) Delete 4.1: Delete jobs posted by Amina Aminova')
        conn.execute(text("""
            DELETE FROM job
            WHERE member_user_id IN (
                SELECT m.member_user_id
                FROM member m JOIN users u ON m.member_user_id = u.user_id
                WHERE u.given_name = 'Amina' AND u.surname = 'Aminova'
            )
        """))
        print('Remaining jobs:')
        for r in conn.execute(text('SELECT job_id, member_user_id, required_caregiving_type FROM job ORDER BY job_id')):
            print(r._asdict())

        print('\n4) Delete 4.2: Delete members living on Kabanbay Batyr')
        rows = conn.execute(text("SELECT member_user_id FROM address WHERE street ILIKE 'Kabanbay Batyr'")).fetchall()
        member_ids = [r[0] for r in rows]
        if member_ids:
            conn.execute(text("DELETE FROM member WHERE member_user_id = ANY(:ids)"), {'ids': member_ids})
            print('Deleted member_user_ids:', member_ids)
        else:
            print('No members found on that street')
        print('Remaining members:')
        for r in conn.execute(text('SELECT member_user_id, house_rules FROM member ORDER BY member_user_id')):
            print(r._asdict())

        print('\n5.1) Caregiver and Member names for accepted appointments')
        q = text("""
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
        """)
        for r in conn.execute(q):
            print(r._asdict())

        print('\n5.2) Jobs with "soft-spoken" in requirements')
        for r in conn.execute(text("SELECT job_id, other_requirements FROM job WHERE other_requirements ILIKE '%soft-spoken%'") ):
            print(r._asdict())

        print('\n5.3) Work hours of all babysitter appointments (caregivers with Babysitter type)')
        q = text("""
            SELECT a.appointment_id, a.work_hours, c.caregiving_type,
                   cu.given_name || ' ' || cu.surname AS caregiver_name,
                   a.appointment_date
            FROM appointment a
            JOIN caregiver c ON a.caregiver_user_id = c.caregiver_user_id
            JOIN users cu ON c.caregiver_user_id = cu.user_id
            WHERE c.caregiving_type = 'Babysitter'
            ORDER BY a.appointment_id
        """)
        for r in conn.execute(q):
            print(r._asdict())

        print('\n5.4) Members looking for Elderly Care in Astana with "No pets" rule')
        q = text("""
            SELECT j.job_id, mu.given_name, mu.surname, a.street, u.city, m.house_rules
            FROM job j
            JOIN member m ON j.member_user_id = m.member_user_id
            JOIN users u ON m.member_user_id = u.user_id
            LEFT JOIN address a ON m.member_user_id = a.member_user_id
            JOIN users mu ON m.member_user_id = mu.user_id
            WHERE j.required_caregiving_type ILIKE 'Elderly Care'
              AND (u.city ILIKE 'Astana' OR a.town ILIKE 'Astana')
              AND m.house_rules ILIKE '%No pets%'
        """)
        for r in conn.execute(q):
            print(r._asdict())

        print('\n6.1) Applicant count per job')
        q = text('SELECT job_id, COUNT(*) AS applicant_count FROM job_application GROUP BY job_id ORDER BY job_id')
        for r in conn.execute(q):
            print(r._asdict())

        print('\n6.2) Total hours for accepted appointments')
        r = conn.execute(text("SELECT COALESCE(SUM(work_hours),0) AS total_hours FROM appointment WHERE status='accepted'"))
        print(r.fetchone()._asdict())

        print('\n6.3) Average hourly_rate of caregivers who have accepted appointments')
        q = text("""
            SELECT AVG(c.hourly_rate) AS avg_hourly
            FROM caregiver c
            JOIN appointment a ON a.caregiver_user_id = c.caregiver_user_id
            WHERE a.status = 'accepted'
        """)
        print(conn.execute(q).fetchone()._asdict())

        print('\n6.4) Caregivers earning above average (for those with accepted appointments)')
        avg_row = conn.execute(text("""
            SELECT AVG(c.hourly_rate) AS avg_hourly
            FROM caregiver c
            JOIN appointment a ON a.caregiver_user_id = c.caregiver_user_id
            WHERE a.status='accepted'
        """)).fetchone()
        avg_hourly = avg_row.avg_hourly if avg_row and avg_row.avg_hourly is not None else 0
        print('Average hourly_rate (accepted):', avg_hourly)
        q = text("""
            SELECT c.caregiver_user_id, u.given_name, u.surname, c.hourly_rate
            FROM caregiver c
            JOIN users u ON c.caregiver_user_id = u.user_id
            WHERE c.hourly_rate > :avg
        """)
        for r in conn.execute(q, {'avg': avg_hourly}):
            print(r._asdict())

        print('\n7) Total cost for all accepted appointments (sum of work_hours * caregiver hourly_rate)')
        q = text("""
            SELECT COALESCE(SUM(a.work_hours * c.hourly_rate),0) AS total_cost
            FROM appointment a
            JOIN caregiver c ON a.caregiver_user_id = c.caregiver_user_id
            WHERE a.status = 'accepted'
        """)
        print(conn.execute(q).fetchone()._asdict())

        print('\n8) Create/Select view job_applicants (applications with applicant info)')
        conn.execute(text("""
            CREATE OR REPLACE VIEW job_applicants AS
            SELECT ja.job_id, ja.date_applied, u.user_id AS applicant_user_id, u.given_name, u.surname, c.caregiving_type, c.hourly_rate
            FROM job_application ja
            JOIN caregiver c ON ja.caregiver_user_id = c.caregiver_user_id
            JOIN users u ON c.caregiver_user_id = u.user_id
        """))
        for r in conn.execute(text('SELECT * FROM job_applicants ORDER BY job_id, applicant_user_id')):
            print(r._asdict())

if __name__ == '__main__':
    run()
