# **Advanced E-Learning System - Database Design** 

**Optimized Data Structure for Seamless Online Learning** 

This project represents the **database design** for the **Advanced E-Learning System**, developed as a final project for my semester. The database was crafted to support dynamic course management, user roles, and interactive learning experiences, ensuring flexibility, scalability, and performance.

---

# **Project Overview**

The **Advanced E-Learning System Database** is designed to power a modern online learning platform. It optimizes data flow between **students**, **instructors**, and **admins** by supporting course enrollment, content delivery, and progress tracking.

## **Database Design Structure**

```plaintext
📁 e_learning
│
├── elearning_project.pdf    # Detailed overview of the database alongside various functionalties
├── elearning_dbms.sql       # The main database schema file
├── elearning_erd.png        # Database ERD diagram    
└── README.md                # You're reading it!
```

# **Core Features of the Database Design**:

- **User Roles**: Defines roles like **Students**, **Instructors**, and **Admins**.
- **Course Management**: Supports multi-level courses with **modules**, **lessons**, **assignments** and **quizzes**.
- **Enrollments & Progress**: Tracks students’ course enrollments, lesson completion, and quiz scores.
- **Instructors & Content**: Allows instructors to manage course content dynamically.

# **Database Schema Overview**

The database schema consists of well-defined tables with appropriate relationships to ensure integrity and scalability.

## **Key Entities**:
- **Users**: Stores information for all users (students, instructors, admins).
- **Courses**: Defines the courses offered, including titles, descriptions, and levels.
- **Modules**: Organizes course content into modules.
- **Lessons**: Details lessons under each module (text, video, quiz types).
- **Enrollments**: Tracks which students are enrolled in which courses.


## **Table Relationships**:
- **Users ↔ Courses**: Instructors create courses.
- **Students ↔ Enrollments ↔ Courses**: Students enroll in courses.
- **Courses ↔ Modules ↔ Lessons**: Lessons and quizzes are nested inside course modules.


## **Security and Integrity**
The database design ensures:

- **Foreign Key Constraints** to maintain referential integrity.
- **User Roles** for access control and to ensure appropriate permissions.
- **Normalized Schema** to avoid redundancy and optimize performance.


## Use Cases Covered
**Course Enrollment**: Tracks student enrollments and course progress.
**Instructor Management**: Allows instructors to add/edit courses and manage students.
**Content Delivery**: Supports lesson structuring and quiz integration for dynamic learning.


# **Setting Up the Database Locally**

Follow these steps to set up the database on your local machine:

1. **Clone the Repository**:
    ```bash
    git clone https://github.com/vinabi/advanced-elearning-database.git
    ```

2. **Import Database Schema**:
    - Ensure your SQL server (e.g., SQLite or MySQL) is running.
    - Import the database schema using the provided SQL file:
      ```bash
      mysql -u [user] -p [database] < elearning_dbms.sql
      ```

3. **Verify Table Structures**:
    - Check the database to ensure all tables are set up correctly:
      ```sql
      show tables;
      ```

## **Planned Database Improvements**:
Activity Logs: Tracking student interactions within the platform.
Advanced Analytics: Generate insights from user activity and course performance.
Content Versioning: Supporting version control for course content updates.

### **Future Enhancements**
**Planned Database Improvements**:
- __Activity Logs__: Tracking student interactions within the platform.
- __Advanced Analytics__: Generate insights from user activity and course performance.
- __Content Versioning__: Supporting version control for course content updates.

