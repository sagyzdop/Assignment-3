from flask import Flask, render_template, request, redirect, url_for, flash
from sqlalchemy import create_engine, text
from sqlalchemy.pool import NullPool
from dotenv import load_dotenv
import os

load_dotenv()

app = Flask(__name__)
app.secret_key = 'your_secret_key_here'
DATABASE_URL = os.environ.get('DATABASE_URL', 'postgresql://postgres:postgres@localhost:5432/caregivers_db')
engine = create_engine(DATABASE_URL, poolclass=NullPool)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/users')
def users():
    with engine.connect() as conn:
        query = text("SELECT * FROM users ORDER BY user_id")
        users_list = conn.execute(query).fetchall()
    return render_template('users.html', users=users_list)

@app.route('/create_user', methods=['POST'])
def create_user():
    try:
        with engine.begin() as conn:
            query = text("""
                INSERT INTO users (email, given_name, surname, city, phone_number, profile_description, password)
                VALUES (:email, :given_name, :surname, :city, :phone_number, :profile_description, :password)
            """)
            conn.execute(query, {
                'email': request.form.get('email'),
                'given_name': request.form.get('given_name'),
                'surname': request.form.get('surname'),
                'city': request.form.get('city'),
                'phone_number': request.form.get('phone_number'),
                'profile_description': request.form.get('profile_description'),
                'password': request.form.get('password')
            })
        flash('User created successfully!', 'success')
    except Exception as e:
        flash(f'Error: {str(e)}', 'danger')
    return redirect(url_for('users'))

@app.route('/update_user/<int:user_id>', methods=['POST'])
def update_user(user_id):
    try:
        with engine.begin() as conn:
            query = text("""
                UPDATE users SET email = :email, given_name = :given_name, surname = :surname,
                city = :city, phone_number = :phone_number, profile_description = :profile_description
                WHERE user_id = :user_id
            """)
            conn.execute(query, {
                'user_id': user_id,
                'email': request.form.get('email'),
                'given_name': request.form.get('given_name'),
                'surname': request.form.get('surname'),
                'city': request.form.get('city'),
                'phone_number': request.form.get('phone_number'),
                'profile_description': request.form.get('profile_description')
            })
        flash('User updated successfully!', 'success')
    except Exception as e:
        flash(f'Error: {str(e)}', 'danger')
    return redirect(url_for('users'))

@app.route('/delete_user/<int:user_id>', methods=['POST'])
def delete_user(user_id):
    try:
        with engine.begin() as conn:
            conn.execute(text("DELETE FROM users WHERE user_id = :user_id"), {'user_id': user_id})
        flash('User deleted successfully!', 'success')
    except Exception as e:
        flash(f'Error: {str(e)}', 'danger')
    return redirect(url_for('users'))

@app.route('/caregivers')
def caregivers():
    with engine.connect() as conn:
        query = text("""
            SELECT c.*, u.given_name, u.surname, u.email
            FROM caregiver c
            JOIN users u ON c.caregiver_user_id = u.user_id
            ORDER BY c.caregiver_user_id
        """)
        caregivers_list = conn.execute(query).fetchall()
        users_query = text("SELECT user_id, given_name, surname FROM users ORDER BY given_name")
        users_list = conn.execute(users_query).fetchall()
    return render_template('caregivers.html', caregivers=caregivers_list, users=users_list)

@app.route('/create_caregiver', methods=['POST'])
def create_caregiver():
    try:
        with engine.begin() as conn:
            query = text("""
                INSERT INTO caregiver (caregiver_user_id, photo, gender, caregiving_type, hourly_rate)
                VALUES (:user_id, :photo, :gender, :caregiving_type, :hourly_rate)
            """)
            conn.execute(query, {
                'user_id': request.form.get('user_id'),
                'photo': request.form.get('photo'),
                'gender': request.form.get('gender'),
                'caregiving_type': request.form.get('caregiving_type'),
                'hourly_rate': request.form.get('hourly_rate')
            })
        flash('Caregiver created successfully!', 'success')
    except Exception as e:
        flash(f'Error: {str(e)}', 'danger')
    return redirect(url_for('caregivers'))

@app.route('/update_caregiver/<int:caregiver_id>', methods=['POST'])
def update_caregiver(caregiver_id):
    try:
        with engine.begin() as conn:
            query = text("""
                UPDATE caregiver SET photo = :photo, gender = :gender,
                caregiving_type = :caregiving_type, hourly_rate = :hourly_rate
                WHERE caregiver_user_id = :caregiver_id
            """)
            conn.execute(query, {
                'caregiver_id': caregiver_id,
                'photo': request.form.get('photo'),
                'gender': request.form.get('gender'),
                'caregiving_type': request.form.get('caregiving_type'),
                'hourly_rate': request.form.get('hourly_rate')
            })
        flash('Caregiver updated successfully!', 'success')
    except Exception as e:
        flash(f'Error: {str(e)}', 'danger')
    return redirect(url_for('caregivers'))

@app.route('/delete_caregiver/<int:caregiver_id>', methods=['POST'])
def delete_caregiver(caregiver_id):
    try:
        with engine.begin() as conn:
            conn.execute(text("DELETE FROM caregiver WHERE caregiver_user_id = :caregiver_id"), {'caregiver_id': caregiver_id})
        flash('Caregiver deleted successfully!', 'success')
    except Exception as e:
        flash(f'Error: {str(e)}', 'danger')
    return redirect(url_for('caregivers'))

@app.route('/members')
def members():
    with engine.connect() as conn:
        query = text("""
            SELECT m.*, u.given_name, u.surname, u.email
            FROM member m
            JOIN users u ON m.member_user_id = u.user_id
            ORDER BY m.member_user_id
        """)
        members_list = conn.execute(query).fetchall()
        users_query = text("SELECT user_id, given_name, surname FROM users ORDER BY given_name")
        users_list = conn.execute(users_query).fetchall()
    return render_template('members.html', members=members_list, users=users_list)

@app.route('/create_member', methods=['POST'])
def create_member():
    try:
        with engine.begin() as conn:
            query = text("""
                INSERT INTO member (member_user_id, house_rules, dependent_description)
                VALUES (:user_id, :house_rules, :dependent_description)
            """)
            conn.execute(query, {
                'user_id': request.form.get('user_id'),
                'house_rules': request.form.get('house_rules'),
                'dependent_description': request.form.get('dependent_description')
            })
        flash('Member created successfully!', 'success')
    except Exception as e:
        flash(f'Error: {str(e)}', 'danger')
    return redirect(url_for('members'))

@app.route('/update_member/<int:member_id>', methods=['POST'])
def update_member(member_id):
    try:
        with engine.begin() as conn:
            query = text("""
                UPDATE member SET house_rules = :house_rules, dependent_description = :dependent_description
                WHERE member_user_id = :member_id
            """)
            conn.execute(query, {
                'member_id': member_id,
                'house_rules': request.form.get('house_rules'),
                'dependent_description': request.form.get('dependent_description')
            })
        flash('Member updated successfully!', 'success')
    except Exception as e:
        flash(f'Error: {str(e)}', 'danger')
    return redirect(url_for('members'))

@app.route('/delete_member/<int:member_id>', methods=['POST'])
def delete_member(member_id):
    try:
        with engine.begin() as conn:
            conn.execute(text("DELETE FROM member WHERE member_user_id = :member_id"), {'member_id': member_id})
        flash('Member deleted successfully!', 'success')
    except Exception as e:
        flash(f'Error: {str(e)}', 'danger')
    return redirect(url_for('members'))

@app.route('/jobs')
def jobs():
    with engine.connect() as conn:
        query = text("""
            SELECT j.*, u.given_name, u.surname
            FROM job j
            JOIN member m ON j.member_user_id = m.member_user_id
            JOIN users u ON m.member_user_id = u.user_id
            ORDER BY j.job_id
        """)
        jobs_list = conn.execute(query).fetchall()
        members_query = text("""
            SELECT m.member_user_id, u.given_name || ' ' || u.surname AS name
            FROM member m JOIN users u ON m.member_user_id = u.user_id
        """)
        members_list = conn.execute(members_query).fetchall()
    return render_template('jobs.html', jobs=jobs_list, members=members_list)

@app.route('/create_job', methods=['POST'])
def create_job():
    try:
        with engine.begin() as conn:
            query = text("""
                INSERT INTO job (member_user_id, required_caregiving_type, other_requirements, date_posted)
                VALUES (:member_id, :caregiving_type, :requirements, :date_posted)
            """)
            conn.execute(query, {
                'member_id': request.form.get('member_id'),
                'caregiving_type': request.form.get('caregiving_type'),
                'requirements': request.form.get('requirements'),
                'date_posted': request.form.get('date_posted')
            })
        flash('Job created successfully!', 'success')
    except Exception as e:
        flash(f'Error: {str(e)}', 'danger')
    return redirect(url_for('jobs'))

@app.route('/update_job/<int:job_id>', methods=['POST'])
def update_job(job_id):
    try:
        with engine.begin() as conn:
            query = text("""
                UPDATE job SET required_caregiving_type = :caregiving_type,
                other_requirements = :requirements, date_posted = :date_posted
                WHERE job_id = :job_id
            """)
            conn.execute(query, {
                'job_id': job_id,
                'caregiving_type': request.form.get('caregiving_type'),
                'requirements': request.form.get('requirements'),
                'date_posted': request.form.get('date_posted')
            })
        flash('Job updated successfully!', 'success')
    except Exception as e:
        flash(f'Error: {str(e)}', 'danger')
    return redirect(url_for('jobs'))

@app.route('/delete_job/<int:job_id>', methods=['POST'])
def delete_job(job_id):
    try:
        with engine.begin() as conn:
            conn.execute(text("DELETE FROM job WHERE job_id = :job_id"), {'job_id': job_id})
        flash('Job deleted successfully!', 'success')
    except Exception as e:
        flash(f'Error: {str(e)}', 'danger')
    return redirect(url_for('jobs'))

@app.route('/appointments')
def appointments():
    with engine.connect() as conn:
        query = text("""
            SELECT a.*, 
                   cu.given_name || ' ' || cu.surname AS caregiver_name,
                   mu.given_name || ' ' || mu.surname AS member_name
            FROM appointment a
            JOIN caregiver c ON a.caregiver_user_id = c.caregiver_user_id
            JOIN users cu ON c.caregiver_user_id = cu.user_id
            JOIN member m ON a.member_user_id = m.member_user_id
            JOIN users mu ON m.member_user_id = mu.user_id
            ORDER BY a.appointment_date DESC
        """)
        appointments_list = conn.execute(query).fetchall()
        
        caregivers_query = text("""
            SELECT c.caregiver_user_id, u.given_name || ' ' || u.surname AS name
            FROM caregiver c JOIN users u ON c.caregiver_user_id = u.user_id
        """)
        caregivers_list = conn.execute(caregivers_query).fetchall()
        
        members_query = text("""
            SELECT m.member_user_id, u.given_name || ' ' || u.surname AS name
            FROM member m JOIN users u ON m.member_user_id = u.user_id
        """)
        members_list = conn.execute(members_query).fetchall()
    
    return render_template('appointments.html', appointments=appointments_list, 
                         caregivers=caregivers_list, members=members_list)

@app.route('/create_appointment', methods=['POST'])
def create_appointment():
    try:
        with engine.begin() as conn:
            query = text("""
                INSERT INTO appointment (caregiver_user_id, member_user_id, appointment_date, 
                appointment_time, work_hours, status)
                VALUES (:caregiver_id, :member_id, :appointment_date, :appointment_time, :work_hours, :status)
            """)
            conn.execute(query, {
                'caregiver_id': request.form.get('caregiver_id'),
                'member_id': request.form.get('member_id'),
                'appointment_date': request.form.get('appointment_date'),
                'appointment_time': request.form.get('appointment_time'),
                'work_hours': request.form.get('work_hours'),
                'status': request.form.get('status', 'pending')
            })
        flash('Appointment created successfully!', 'success')
    except Exception as e:
        flash(f'Error: {str(e)}', 'danger')
    return redirect(url_for('appointments'))

@app.route('/update_appointment/<int:appointment_id>', methods=['POST'])
def update_appointment(appointment_id):
    try:
        with engine.begin() as conn:
            query = text("""
                UPDATE appointment SET appointment_date = :appointment_date, appointment_time = :appointment_time,
                work_hours = :work_hours, status = :status
                WHERE appointment_id = :appointment_id
            """)
            conn.execute(query, {
                'appointment_id': appointment_id,
                'appointment_date': request.form.get('appointment_date'),
                'appointment_time': request.form.get('appointment_time'),
                'work_hours': request.form.get('work_hours'),
                'status': request.form.get('status')
            })
        flash('Appointment updated successfully!', 'success')
    except Exception as e:
        flash(f'Error: {str(e)}', 'danger')
    return redirect(url_for('appointments'))

@app.route('/delete_appointment/<int:appointment_id>', methods=['POST'])
def delete_appointment(appointment_id):
    try:
        with engine.begin() as conn:
            conn.execute(text("DELETE FROM appointment WHERE appointment_id = :appointment_id"), 
                        {'appointment_id': appointment_id})
        flash('Appointment deleted successfully!', 'success')
    except Exception as e:
        flash(f'Error: {str(e)}', 'danger')
    return redirect(url_for('appointments'))

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
