# Video Demonstration Script
## CSCI 341 Assignment 3: Online Caregivers Platform

**Total Duration: 5-7 minutes**

---

## INTRODUCTION (30 seconds)

"Hello! I'm presenting Assignment 3 for CSCI 341 - the Online Caregivers Platform. This project demonstrates a complete database-backed web application with three main parts: database design, query operations, and a CRUD web interface for all database tables. Let me walk you through each component."

---

## PART 1: DATABASE DESIGN (1 minute)

### Show `schema_and_data.sql` file

"First, let's look at Part 1 - the database design. I've created a normalized PostgreSQL schema with 7 tables."

**Open schema_and_data.sql and scroll through highlighting:**

1. **Users table** - "The central table storing user information like email, name, city, and phone."

2. **Caregiver and Member tables** - "These have a one-to-one relationship with Users, implementing specialized roles. Caregivers have hourly rates and caregiving types, while Members have house rules and dependent descriptions."

3. **Address table** - "Each member has one address with street and town information."

4. **Job and Job_Application tables** - "Members post jobs, and caregivers apply through a many-to-many relationship."

5. **Appointment table** - "This tracks scheduled work between caregivers and members, with date, time, work hours, and status."

6. **Seed data** - "I've inserted over 10 realistic records per table, including the required test data: Arman Armanov, Amina Aminova, addresses on Kabanbay Batyr street, and jobs requiring 'soft-spoken' caregivers."

### Show terminal:
```bash
python3 load_schema.py
```

"The schema loads automatically to Supabase cloud database on first run."

---

## PART 2: QUERY OPERATIONS (2-3 minutes)

### Show `queries.py` file

"Part 2 demonstrates 14 different SQL operations using SQLAlchemy. Let me run the script to show you the results."

**Run in terminal:**
```bash
python3 queries.py
```

**As it executes, explain each section:**

### 1. Updates (3.1 & 3.2)
"First, we update Arman Armanov's phone number to +77773414141."
*Show output confirming the change*

"Then we adjust caregiver hourly rates - adding $0.30 for rates under $10, or 10% for rates $10 and above."
*Show the updated rates*

### 2. Deletes (4.1 & 4.2)
"Next, we delete all jobs posted by Amina Aminova."
*Show remaining jobs list*

"And we delete members living on Kabanbay Batyr street."
*Show deleted member IDs and remaining members*

### 3. Simple Queries (5.1-5.4)
**5.1** - "This query shows caregiver and member names for accepted appointments with dates and hours."
*Point to the joined data*

**5.2** - "We find all jobs requiring 'soft-spoken' caregivers."
*Show the 2 matching jobs*

**5.3** - "Work hours for all babysitter appointments."
*Show the 3 babysitter appointments*

**5.4** - "Members in Astana looking for Elderly Care with 'No pets' house rules."
*Show the filtered results*

### 4. Complex Queries (6.1-6.4)
**6.1** - "Count of applicants per job using GROUP BY."
*Show applicant counts*

**6.2** - "Total work hours for accepted appointments: 12.5 hours."

**6.3** - "Average hourly rate of caregivers with accepted appointments: $13.17."

**6.4** - "Caregivers earning above the average rate."
*Show the 3 caregivers*

### 5. Derived Attribute (7)
"Calculating total cost of accepted appointments by multiplying work hours by hourly rates: $163.00."

### 6. View Creation (8)
"Finally, we create a view called job_applicants that joins applications with caregiver information."
*Show the view output*

"All 14 queries executed successfully!"

---

## PART 3: WEB APPLICATION (2-3 minutes)

### Show browser at http://127.0.0.1:5000/

"Part 3 is a full-stack Flask web application with complete CRUD functionality for all database tables."

### Homepage Dashboard

**Point out the interface:**
- "Clean Bootstrap 5 design with gradient hero section"
- "Dashboard with cards for all 5 main entities: Users, Caregivers, Members, Jobs, and Appointments"
- "Click any card to manage that entity"

### Demonstrate Users Management
1. Click "View Users" card
2. "This page shows all users in the database with full details: email, name, city, phone, and description"
3. Click "Add User" button
4. "Modal form for creating new users with all required fields"
5. Fill in a test user and create
6. "Notice the success message and new user appears in table"
7. Click "Edit" on a user to show update functionality
8. "Delete button available for each user"

### Demonstrate Caregivers Management
1. Return to home, click "View Caregivers"
2. "Caregivers table shows linked user information plus caregiver-specific fields: gender, type, hourly rate, and photo URL"
3. Click "Add Caregiver"
4. "We select an existing user and add caregiver details"
5. Show the dropdown of available users
6. "Complete CRUD: create, read, update, and delete operations available"

### Demonstrate Members Management
1. Return to home, click "View Members"
2. "Members table shows user info with house rules and dependent descriptions"
3. Demonstrate create/edit/delete similar to previous sections
4. "Each member links to an existing user account"

### Demonstrate Jobs Management
1. Return to home, click "View Jobs"
2. "Job postings table shows which member posted it, required caregiving type, other requirements, and date posted"
3. Click "Add Job"
4. "Select a member from the dropdown and specify job requirements"
5. "This is where members would post positions they need filled"

### Demonstrate Appointments Management
1. Return to home, click "View Appointments"
2. "The appointments table shows caregiver names and member names through JOIN queries"
3. "Complete scheduling information: date, time, work hours, and status"
4. Click "Add Appointment"
5. Fill in appointment form:
   - Select a caregiver
   - Select a member
   - Date: tomorrow's date
   - Time: 14:00
   - Work hours: 4
   - Status: Pending
6. Click "Create Appointment"
7. "New appointment appears immediately"
8. Click "Edit" to update status to "Confirmed"
9. "Delete option available with confirmation prompt"

### Navigation Flow
"The application provides seamless navigation between all tables. Each page has consistent design with the same navbar, making it easy to manage any part of the platform."

---

## TECHNICAL DETAILS (30 seconds)

### Show file structure briefly

"The project uses:
- PostgreSQL 15 on Supabase cloud platform
- Python 3 with SQLAlchemy 2.0 and NullPool for transaction pooling
- Flask 3.0 for the web framework
- Bootstrap 5 for responsive UI design
- PythonAnywhere for frontend hosting (full-stack locally)

Everything is version controlled and includes:
- Automatic schema initialization on startup
- requirements.txt for Python dependencies with python-dotenv
- Comprehensive README with deployment instructions
- Executive summary documenting all components

Note: External database connections require paid PythonAnywhere accounts, so full deployment runs locally with cloud database."

---

## DEPLOYMENT READINESS (20 seconds)

### Show browser at https://sagyzdop.pythonanywhere.com

"The application frontend is deployed to PythonAnywhere and accessible online. However, PythonAnywhere's free tier does not allow external database connections - this requires a paid account at $5 per month.

Rather than pay for an assignment, I'm demonstrating the full-stack application running locally with Supabase cloud database. This shows the complete production-ready architecture."

### Show localhost:5000 working

"As you can see, the application works perfectly with the cloud database from localhost. The code is identical - only the hosting platform differs. For free full-stack deployment, platforms like Render.com or Railway.app support external databases without restrictions."

---

## CONCLUSION (20 seconds)

"To summarize, this project delivers:
1. A normalized PostgreSQL database with 10+ records per table
2. 14 comprehensive SQL queries covering updates, deletes, joins, aggregations, and views
3. A fully functional CRUD web application for all 5 main entities: Users, Caregivers, Members, Jobs, and Appointments

All assignment requirements for Parts 1, 2, and 3 are complete and demonstrated. Thank you!"

---

## TIPS FOR RECORDING:

1. **Before recording:**
   - Clear browser cache and restart Flask app for clean demo
   - Have terminal ready with commands
   - Test the entire flow once
   - Close unnecessary applications

2. **During recording:**
   - Speak clearly and at moderate pace
   - Use mouse to highlight important parts of screen
   - Zoom in on code when showing specifics
   - Keep browser at reasonable zoom level (110-125%)

3. **If something goes wrong:**
   - Don't panic! Just say "Let me try that again"
   - Having data already in the DB is expected, not a problem

4. **Time management:**
   - Part 1: ~1 minute
   - Part 2: ~2.5 minutes
   - Part 3: ~2.5 minutes
   - Intro/Conclusion: ~1 minute
   - Total: 5-7 minutes

**Good luck with your recording!**
