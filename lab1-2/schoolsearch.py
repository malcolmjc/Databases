import sys

# Lab 1-1: Malcolm Craney, Dylan Halland, Owen Kehlenbeck

class Student:
   def __init__(self, last_name, first_name, grade, classroom, bus, gpa):
      self.last_name = last_name
      self.first_name = first_name
      self.grade = grade
      self.classroom = classroom
      self.bus = bus
      self.gpa = gpa

class Teacher:
   def __init__(self, last_name, first_name, classroom):
      self.last_name = last_name
      self.first_name = first_name
      self.classroom = classroom

class Query:
   def __init__(self, choice, params):
      self.choice = choice
      self.params = params

def parse_students():
   students = dict()
   try:
      fp = open('./list.txt', 'r')
      line = fp.readline()
      while line:
         line = line.strip()
         line = line.replace(' ', '')
         fields = line.split(',')
         student = Student(fields[0], fields[1], fields[2], fields[3], fields[4], fields[5])
         if student.classroom in students:
            students[student.classroom].append(student)
         else:
            students[student.classroom] = [student]
         line = fp.readline()
      fp.close()
      return students
   
   except:
      print('Could not read list.txt')
      sys.exit(1)

def parse_teachers():
   teachers = dict()
   try:
      fp = open('./teachers.txt', 'r')
      line = fp.readline()
      while line:
         line = line.strip()
         line = line.replace(' ', '')
         fields = line.split(',')
         teacher = Teacher(fields[0], fields[1], fields[2])
         teachers[teacher.classroom] = teacher
         line = fp.readline()
      fp.close()
      return teachers
   
   except:
      print('Could not read teachers.txt')
      sys.exit(1)

def get_query(prompt):
   query = input(prompt)
   separated = query.split()
   return Query(separated[0].replace(':', '') if len(separated) > 0 else 'Null', separated[1:])

def student_command(students_dict, last_name):
   matching_students = []
   for classroom, students in students_dict.items():
      for student in students:
         if student.last_name == last_name:
            matching_students.append(student)

   return matching_students

def student_command_output(students, is_bus, teachers):
   for student in students:
      teacher = teachers[student.classroom]
      if not is_bus:
         # last name, first name, grade and classroom assignment for
         # each student found and the name of their teacher (last and first name).
         print('%s,%s,%s,%s,%s,%s' % (student.last_name, student.first_name, student.grade, \
                                      student.classroom, teacher.last_name, teacher.first_name))
      
      else:
         # For each entry found, print the last name, First name and the bus route the student takes.
         print('%s,%s,%s' % (student.last_name, student.first_name, student.bus))

def teacher_command(students_dict, last_name, teachers):
   matching_students = []
   for teacher in list(teachers.values()):
      if teacher.last_name == last_name:
         matching_students += students_dict[teacher.classroom]

   return matching_students

def teacher_command_output(students):
   for student in students:
      # For each entry found, print the last and the First name of the student.
      print(student.last_name + ',' + student.first_name)
      
def get_bus_info(students_dict, query):
   if not query.params:
      print("Error: please enter a bus route number")
      
   else:
      for students in list(students_dict.values()):
         for student in students:
            if student.bus == query.params[0]:
               print('%s,%s,%s,%s' % (student.last_name,student.first_name,student.grade, \
                                       student.classroom))

def get_info(students_dict):
   info = [0] * 7
   for students in students_dict:
      for s in students:
         if s.grade == '0':
            info[0] += 1
         elif s.grade == '1':
            info[1] += 1
         elif s.grade == '2':
            info[2] += 1
         elif s.grade == '3':
            info[3] += 1
         elif s.grade == '4':
            info[4] += 1
         elif s.grade == '5':
            info[5] += 1   
         elif s.grade == '6':
            info[6] += 1

   for i in range(len(info)):
      print('%s: %s' % (i, info[i]))
      
def grade_command(students_dict, qparams0, qparams1, teachers):
   highest = 0.0
   lowest = 5.0
   studs = []
   students = list(students_dict.values())
   if qparams1 == 'L' or qparams1 == 'Low':
      for stds in students:
         for s in stds:
            if s.grade == qparams0 and float(s.gpa) < lowest:
               studs = [s]
               lowest = float(s.gpa)
            elif s.grade == qparams0 and float(s.gpa) == lowest:
               studs.append(s)
   elif qparams1 == 'H' or qparams1 == 'High':
      for stds in students:
         for s in stds:
            if s.grade == qparams0 and float(s.gpa) > highest:
               studs = [s]
               highest = float(s.gpa)
            elif s.grade == qparams0 and float(s.gpa) == highest:
               studs.append(s)
   for x in studs:
      teacher = teachers[x.classroom]
      studinfo = "%s,%s,%s,%s,%s,%s" % (x.last_name, x.first_name, x.gpa, teacher.last_name, teacher.first_name, x.bus)
      print(studinfo)

def average_command(students_dict, qparams0):
   total = 0.0
   numstudents = 0
   students = list(students_dict.values())
   for stds in students:
      for s in stds:
         if s.grade == qparams0 :
            total += float(s.gpa)
            numstudents += 1
   if numstudents != 0 :
      response = "Grade: %s Average GPA: %f" % (qparams0, total/numstudents)
      print(response)

def get_grades_teachers_command(teachers, students_dict, grade):
   classrooms = []
   for students in list(students_dict.values()):
      for s in students:
         if s.grade == grade:
            if s.classroom in classrooms:
               pass
            else:
               classrooms.append(s.classroom)

   for teacher in list(teachers.values()):
      if teacher.classroom in classrooms:
         print('%s,%s' % (teacher.last_name, teacher.first_name))

def get_classroom_enrollment(teachers, students_dict):
   classrooms = []
   enrollment = []

   for teacher in list(teachers.values()):
      classrooms.append(teacher.classroom)
      enrollment.append(0)

   for students in list(students_dict.values()):
      for s in students:
         for i in range(len(classrooms)):
            if s.classroom == classrooms[i]:
               enrollment[i] += 1
            

   for j in range(len(enrollment)):
      print("Classroom %s: %s" % (classrooms[j], enrollment[j]))


def main():
   students = parse_students()
   teachers = parse_teachers()
   prompt = 'Enter your command (S[tudent], T[eacher], B[us], G[rade], A[verage], I[nfo], Q[uit]:\n'
   query = get_query(prompt)
   while query.choice != 'Q' and query.choice != 'Quit':
      if query.choice == 'S' or query.choice == 'Student':
         if len(query.params) == 0:
            print('Usage: S[tudent]: <lastname> [B[us]]')
         else:
            matching_students = student_command(students, query.params[0])
            is_bus = len(query.params) == 2 and (query.params[1] == 'B' or query.params[1] == 'Bus')
            student_command_output(matching_students, is_bus, teachers)

      elif query.choice == 'T' or query.choice == 'Teacher':
         if len(query.params) == 0:
            print('T[eacher]: <lastname>')
         
         else:
            matching_students = teacher_command(students, query.params[0], teachers)
            teacher_command_output(matching_students)

      elif query.choice == 'B' or query.choice == 'Bus':
         get_bus_info(students, query)

      elif query.choice == 'G' or query.choice == 'Grade':
         if len(query.params) == 1:
            for stds in list(students.values()):
               for s in stds:
                  if s.grade == query.params[0]:
                     studinf = "%s,%s" % (s.last_name, s.first_name)
                     print(studinf)
         elif len(query.params) > 1:
            grade_command(students, query.params[0], query.params[1], teachers)

      elif query.choice == 'A' or query.choice == 'Average':
         if len(query.params) == 1:
            average_command(students, query.params[0])

      elif query.choice == 'I' or query.choice == 'Info':
         get_info(list(students.values()))

      # NR1
      elif query.choice == 'CRS':
         if len(query.params) == 0:
            print('Usage: CRS: <Classroom Number>')
         elif not query.params[0] in students:
            pass
         else:
            for student in students[query.params[0]]:
               print('%s,%s' % (student.last_name, student.first_name))

       # NR2
      elif query.choice == 'CRT':
         if len(query.params) == 0:
            print('Usage: CRT: <Classroom Number>')
         elif not query.params[0] in teachers:
            pass
         else:
            teacher = teachers[query.params[0]]
            print('%s,%s' % (teacher.last_name, teacher.first_name))

      # NR3
      elif query.choice == 'GT':
         if len(query.params) == 0:
            print('Usage: GT: <Grade>')
         else:
            get_grades_teachers_command(teachers, students, query.params[0])

      # NR4
      elif query.choice == 'CRE':
         get_classroom_enrollment(teachers, students)

      # NR5
      elif query.choice == 'GPAG':
         if len(query.params) == 0:
            print('Usage: GPAG: <Grade>')

      elif query.choice == 'GPAT':
         if len(query.params) == 0:
            print('Usage: GPAT: <Teacher Last Name>')

      elif query.choice == 'GPAB':
         if len(query.params) == 0:
            print('Usage: GPAB: <Bus Route Number>')

      query = get_query(prompt)

if __name__ == '__main__':
   main()
