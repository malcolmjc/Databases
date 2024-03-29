import sys

def strip_data(line):
   line = line.strip()
   return line

def parse_csv(filepath):
   try:
      fp = open(filepath, 'r')
      line = fp.readline()
      line = strip_data(line)
      titles = line.split(',')

      data = []
      while line:
         line = fp.readline()
         line = strip_data(line)
         fields = line.split(',')

         if len(fields) == len(titles):
            data.append(fields)

      fp.close()
      return [titles, data]
   
   except:
      print('Could not read ' + filepath)
      sys.exit(1)

def isfloat(field):
   field = field.replace("'", '')
   split_period = field.split('.')
   return len(split_period) == 2 and split_period[0].isdigit() and split_period[1].isdigit()

month_dict = {'JAN': '1', 'FEB': '2', 'MAR': '3', 'APR': '4', 'MAY': '5', 'JUN': '6', 'JUL': '7', 'AUG': '8', 'SEP': '9', 'OCT': '10', 'NOV': '11', 'DEC': '12'}
# Assumes dates formatted DD-Month-YYYY
def isdate(field):
   field = field.replace("'", '')
   split_dash = field.split('-')
   return len(split_dash) == 3 and split_dash[0].isdigit() and split_dash[1].upper() in month_dict and split_dash[2].isdigit()

# Assumes dates formatted DD-Month-YYYY
def get_date(field):
   field = field.replace("'", '')
   split_dash = field.split('-')
   return "'" + split_dash[2] + '-' + month_dict[split_dash[1].upper()] + '-' + split_dash[0] + "'"

def convert_field(field):
   if field.isdigit() or isfloat(field):
      return field.replace("'", '')
   
   elif isdate(field):
      return get_date(field)

   return field

def get_data_types(data):
   for i in range(len(data)):
      for j in range(len(data[i])):
         data[i][j] = convert_field(data[i][j])

def build_insert_statement(table_name, column_titles, data):
   statement = 'INSERT INTO %s(' % table_name
   if len(column_titles) == 0:
      print('Data doesnt have column titles')
      sys.exit(1)

   statement += column_titles[0]
   for i in range(len(column_titles) - 1):
      statement += ',' + column_titles[i + 1]
   statement += ')\n'

   statement += 'VALUES\n'
   for row in data:
      statement += '   ('
      if len(row) == 0:
         print('Data row: ' + row + ' is corrupted')
         sys.exit(1)

      statement += row[0]
      for i in range(len(row) - 1): 
         statement += ',' + row[i + 1]
      statement += '),\n'

   statement = statement[:len(statement) - 2] + ';'
   print(statement)

def main():
   if len(sys.argv) < 3:
      print('Usage: py parsecsv <path to filename.csv> <table name> {> <output file>}')
      sys.exit(1)

   [column_titles, data] = parse_csv(sys.argv[1])
   get_data_types(data)
   build_insert_statement(sys.argv[2], column_titles, data)

if __name__ == '__main__':
   main()
