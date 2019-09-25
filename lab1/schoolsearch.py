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


def main():
   students = parse_students()
   prompt = 'Enter your command (S[tudent], T[eacher], B[us], G[rade], A[verage], I[nfo], Q[uit]:\n'
   choice = input(prompt)
   while choice != 'Q':
      if choice == 'S' or choice == 'Student':
         pass #TODO

      elif choice == 'T' or choice == 'Teacher':
         pass # TODO

      elif choice == 'B' or choice == 'Bus':
         pass # TODO

      elif choice == 'G' or choice == 'Grade':
         pass # TODO

      elif choice == 'A' or choice == 'Average':
         pass # TODO

      elif choice == 'I' or choice == 'Info':
         pass # TODO

      choice = input(prompt)

if __name__ == '__main__':
   main()
