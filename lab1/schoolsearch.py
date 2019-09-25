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

   finally:
      fp.close()
      return students

def get_query(prompt):
   query = input(prompt)
   separated = query.split()
   return Query(separated[0], separated[1:])

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

def main():
   students = parse_students()
   prompt = 'Enter your command (S[tudent], T[eacher], B[us], G[rade], A[verage], I[nfo], Q[uit]:\n'
   query = get_query(prompt) 
   while query.choice != 'Q':
      if query.choice == 'S' or query.choice == 'Student':
         matching_students = student_command(students, query.params[0])
         is_bus = len(query.params) == 2 and (query.params[1] == 'B' or query.params[1] == 'Bus') 
         student_command_output(matching_students, is_bus)

      elif query.choice == 'T' or query.choice == 'Teacher':
         matching_students = teacher_command(students, query.params[0])
         teacher_command_output(matching_students)

      elif query.choice == 'B' or query.choice == 'Bus':
         pass # TODO

      elif query.choice == 'G' or query.choice == 'Grade':
         pass # TODO

      elif query.choice == 'A' or query.choice == 'Average':
         pass # TODO

      elif query.choice == 'I' or query.choice == 'Info':
         pass # TODO

      query = get_query(prompt) 

if __name__ == '__main__':
   main()
