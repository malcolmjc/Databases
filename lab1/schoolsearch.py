import sys

class Student:
   def __init__(self, last_name, first_name, grade, classroom, bus, gpa, t_last_name, t_first_name):
      self.last_name = last_name
      self.first_name = first_name
      self.grade = grade
      self.classroom = classroom
      self.bus = bus
      self.gpa = gpa
      self.t_last_name = t_last_name
      self.t_first_name = t_first_name

class Query:
   def __init__(self, choice, params):
      self.choice = choice
      self.params = params

def parse_students():
   students = []
   try:
      fp = open('./students.txt', 'r')
      line = fp.readline()
      while line:
         line = line.strip()
         fields = line.split(',')
         student = Student(fields[0], fields[1], fields[2], fields[3], fields[4], fields[5], fields[6], fields[7])
         students.append(student)
         line = fp.readline()
      fp.close()
      return students
   
   except:
      print('Could not read students.txt')
      sys.exit(1)

def get_query(prompt):
   query = input(prompt)
   separated = query.split()
   return Query(separated[0].replace(':', ''), separated[1:])

def student_command(students, last_name):
   matching_students = []
   for student in students:
      if student.last_name == last_name:
         matching_students.append(student)

   return matching_students

def student_command_output(students, is_bus):
   for student in students:
      if not is_bus:
         # last name, first name, grade and classroom assignment for
         # each student found and the name of their teacher (last and first name).
         print('%s,%s,%s,%s,%s,%s' % (student.last_name, student.first_name, student.grade, \
                                      student.classroom, student.t_last_name, student.t_first_name))
      
      else:
         # For each entry found, print the last name, First name and the bus route the student takes.
         print('%s,%s,%s' % (student.last_name, student.first_name, student.bus))
   
def teacher_command(students, last_name):
   matching_students = []
   for student in students:
      if student.t_last_name == last_name:
         matching_students.append(student)

   return matching_students

def teacher_command_output(students):
   for student in students:
      # For each entry found, print the last and the First name of the student.
      print(student.last_name + ',' + student.first_name)
      
def get_bus_info(students, query):
   if not query.params:
      print("Error: please enter a bus route number")
      
   else:
      for student in students:
         if student.bus == query.params[0]:
            print('%s,%s,%s,%s' % (student.last_name,student.first_name,student.grade, \
                                    student.classroom))

def get_info(students):
   info = [0] * 7
   for student in students:
      if student.grade == '0':
         info[0] += 1
      elif student.grade == '1':
         info[1] += 1
      elif student.grade == '2':
         info[2] += 1
      elif student.grade == '3':
         info[3] += 1
      elif student.grade == '4':
         info[4] += 1
      elif student.grade == '5':
         info[5] += 1   
      elif student.grade == '6':
         info[6] += 1

   for i in range(len(info)):
      print('%s: %s' % (i, info[i]))
      
def grade_command(students, qparams0, qparams1):
   highest = 0.0
   lowest = 5.0
   studs = []
   if qparams1 == 'L' or qparams1 == 'Low':
      for s in students:
         if s.grade == qparams0 and float(s.gpa) < lowest:
            studs = [s]
            lowest = float(s.gpa)
         elif s.grade == qparams0 and float(s.gpa) == lowest:
            studs.append(s)
   elif qparams1 == 'H' or qparams1 == 'High':
      for s in students:
         if s.grade == qparams0 and float(s.gpa) > highest:
            studs = [s]
            highest = float(s.gpa)
         elif s.grade == qparams0 and float(s.gpa) == highest:
            studs.append(s)
   for x in studs:
      studinfo = "%s,%s,%s,%s,%s,%s" % (x.last_name, x.first_name, x.gpa, x.t_last_name, x.t_first_name, x.bus)
      print(studinfo)

def average_command(students, qparams0):
   total = 0.0
   numstudents = 0
   for s in students:
      if s.grade == qparams0 :
         total += float(s.gpa)
         numstudents += 1
   if numstudents != 0 :
      response = "Grade: %s Average GPA: %f" % (qparams0, total/numstudents)
      print(response)

def main():
   students = parse_students()
   prompt = 'Enter your command (S[tudent], T[eacher], B[us], G[rade], A[verage], I[nfo], Q[uit]:\n'
   query = get_query(prompt) 
   while query.choice != 'Q':
      if query.choice == 'S' or query.choice == 'Student':
         if len(query.params) == 0:
            print('Usage: S[tudent]: <lastname> [B[us]]')
         else:
            matching_students = student_command(students, query.params[0])
            is_bus = len(query.params) == 2 and (query.params[1] == 'B' or query.params[1] == 'Bus') 
            student_command_output(matching_students, is_bus)

      elif query.choice == 'T' or query.choice == 'Teacher':
         if len(query.params) == 0:
            print('T[eacher]: <lastname>')
         
         else:
            matching_students = teacher_command(students, query.params[0])
            teacher_command_output(matching_students)

      elif query.choice == 'B' or query.choice == 'Bus':
         get_bus_info(students, query)

      elif query.choice == 'G' or query.choice == 'Grade':
         if len(query.params) == 1:
            for s in students:
               if s.grade == query.params[0]:
                  studinf = "%s,%s" % (s.last_name, s.first_name)
                  print(studinf)
         else:
            grade_command(students, query.params[0], query.params[1])

      elif query.choice == 'A' or query.choice == 'Average':
         average_command(students, query.params[0])

      elif query.choice == 'I' or query.choice == 'Info':
         get_info(students)

      query = get_query(prompt) 

if __name__ == '__main__':
   main()
