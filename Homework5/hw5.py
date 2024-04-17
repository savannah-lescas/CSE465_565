import time

"""
  Homework#5

  Add your name here: Savannah Lescas

  You are free to create as many classes within the hw5.py file or across 
  multiple files as you need. However, ensure that the hw5.py file is the 
  only one that contains a __main__ method. This specific setup is crucial 
  because your instructor will run the hw5.py file to execute and evaluate 
  your work.
"""

if __name__ == "__main__": 
    start_time = time.perf_counter()  # Do not remove this line
    '''
    Inisde the __main__, do not add any codes before this line.
    -----------------------------------------------------------
    '''

    
    # write your code here


    '''
    Inside the __main__, do not add any codes after this line.
    ----------------------------------------------------------
    '''
    end_time = time.perf_counter()
    # Calculate the runtime in milliseconds
    runtime_ms = (end_time - start_time) * 1000
    print(f"The runtime of the program is {runtime_ms} milliseconds.")  
    
iFile = "zipcodes.txt"

zipcodeFile = open(iFile, "r")

class SimplePlace:
    # constructor
    def __init__(self, city, zipcode):
        self._city = city
        self._zipcode = zipcode

    # override equals at some point
    
    # getter for city
    def get_city(self):
        return self._city
    
    # setter for city
    def set_city(self, value):
        self._city = value

    # getter for zipcode
    def get_zip(self):
        return self._zipcode
    
    # setter for zipcode
    def set_zip(self, value):
        self._zipcode = value

class Place(SimplePlace):
    def __intit__(self, city, zipcode, state, lat, lon):
        SimplePlace.__init__(self, city, zipcode)
        self._state = state
        self._lat = lat
        self._lon = lon

    # getter for state
    def get_state(self):
      return self._state

    # setter for state
    def set_state(self, value):
        self._state = value

    # getter for latitude
    def get_lat(self):
        return self._lat

    # setter for latitude
    def set_lat(self, value):
        self._lat = value

    # getter for longitude
    def get_lon(self):
        return self._lon

    # setter for longitude
    def set_lon(self, value):
        self._lon = value
