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
    def __init__(self, zipcode, city, state, lat, lon):
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


def createRecord(line):
    parts = line.split('\t')
    return Place(parts[1], parts[3], parts[4], parts[6], parts[7])

def createPlaceList():
    # use map to apply a function to the lines
    # from the file
    placeList = []
    zipcodeFile = open("zipcodes.txt", "r")

    # skip first line
    next(zipcodeFile)
    # uses map to apply the createRecord function on the 
    # zipcdoe file
    placeList.extend(map(createRecord, zipcodeFile))

    zipcodeFile.close()

    return placeList
    
def commonCityNames(placeList):
    state_city_dict = {}

    with open("states.txt", "r") as states:
        # add the states as keys to the dictionary
        for state in states:
            state = state.strip()  # Remove leading/trailing whitespace
            if state:  # Check if the line is not empty
                state_city_dict[state] = set()

        # go through every place object
        for place in placeList:
            state = place.get_state().strip()
            city = place.get_city().strip()

            # if the state of the object is a key in the
            # dictionary, add its city to the key's list of 
            # city values
            if state in state_city_dict.keys():
                state_city_dict[state].add(city)

    # use filter with a lambda to check if the lists
    # contain the same cities



if __name__ == "__main__": 
    start_time = time.perf_counter()  # Do not remove this line
    '''
    Inisde the __main__, do not add any codes before this line.
    -----------------------------------------------------------
    '''

    # code goes here
    placeList = createPlaceList()
    commonCityNames(placeList)


    '''
    Inside the __main__, do not add any codes after this line.
    ----------------------------------------------------------
    '''
    end_time = time.perf_counter()
    # Calculate the runtime in milliseconds
    runtime_ms = (end_time - start_time) * 1000
    print(f"The runtime of the program is {runtime_ms} milliseconds.")  
    
