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
# => I’m competing for BONUS Points <=



"""
still needs implemented:
1- override a method
3- variable positional argument
4- yield
"""

class SimplePlace:
    # constructor
    def __init__(self, city = "", zipcode = 0):
        self._city = city
        self._zipcode = zipcode

    @staticmethod
    def getParts(record):
        return record.get_city() + " " + record.get_zip() + '\n'

    # override ==
    def __eq__(self, other):
        return self.get_zip() == other.get_zip() or self.get_city().lower() == other.get_city().lower()
    
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

    # overriding getParts from parent method
    @staticmethod
    def getParts(record):
        return record.get_lat() + " " + record.get_lon() + '\n'

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
    # lambda function that initializes the part to 'None'
    # if there are no values
    # RealPython.com told me that None is the equivalent of null
    check_null = lambda part: part.strip() if part.strip() else None
    # lat and lon use the lambda to initialize its values
    lat = check_null(parts[6])
    lon = check_null(parts[7])
    return Place(parts[1].strip(), parts[3].strip(), parts[4].strip(), lat, lon)

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
            state = state.strip()
            # check if the line is not empty
            if state: 
                state_city_dict[state] = set()

        # go through every place object
        for place in placeList:
            state = place.get_state()
            city = place.get_city()

            # if the state of the object is a key in the
            # dictionary, add its city to the key's list of 
            # city values
            if state in state_city_dict.keys():
                state_city_dict[state].add(city)

    # use filter with a lambda to get a list of common
    # city names
    # StackOverflow showed me to use all()
    is_common_city = lambda city: all(city in cities for cities in state_city_dict.values())
    # ChatGpt showed me how to use the union part
    common_cities = sorted(set(filter(is_common_city, set.union(*state_city_dict.values()))))

    with open("ComonCityNames.txt", "w") as outputFile:
        for city in common_cities:
            outputFile.write(city + '\n')

def latLon(placeList):
    # opens the new file to write to
    latLonFile = open("LatLon.txt", "w")
    # reads the zips.txt file to read from
    with open("zips.txt", "r") as zips:
        # for every zipcode in zips.txt
        for zip in zips:
            # create the SimplePlace object with the zip
            simpleZip = SimplePlace("", zip.strip())
            # go through every record in placeList
            for record in placeList:
                # use the overrided == method to check if the
                # zipcodes match
                if simpleZip == record:
                    # if they match but the latitude or longitude is 'None'
                    # keep looking
                    if record.get_lat() == None or record.get_lon() == None:
                        continue
                    # otherwise, write the latitude and longitude to the
                    # LatLon.txt file separated by a space
                    else:
                        latLonFile.write(Place.getParts(record))
                        break
    # close LatLon.txt
    latLonFile.close()

def cityStates(placeList):
    # open the files for reading and writing
    inFile = open("cities.txt", "r")
    outFile = open("CityStates.txt", "w")

    for city in inFile:
        # creates a list for the states that share the city name
        states = []
        # strips the city name from the file
        strippedCity = city.strip()
        # creates a SimplePlace object to use the == operator
        simpleCity = SimplePlace(strippedCity, 0)
        # list comprehension
        states = sorted(set([record.get_state() for record in placeList if record == simpleCity]))

        # write the states to the file
        for state in states:
            outFile.write(state + " ")

        outFile.write('\n')
        
    inFile.close()
    outFile.close()


if __name__ == "__main__": 
    start_time = time.perf_counter()  # Do not remove this line
    '''
    Inisde the __main__, do not add any codes before this line.
    -----------------------------------------------------------
    '''

    # code goes here
    placeList = createPlaceList()
    commonCityNames(placeList)
    latLon(placeList)
    cityStates(placeList)


    '''
    Inside the __main__, do not add any codes after this line.
    ----------------------------------------------------------
    '''
    end_time = time.perf_counter()
    # Calculate the runtime in milliseconds
    runtime_ms = (end_time - start_time) * 1000
    print(f"The runtime of the program is {runtime_ms} milliseconds.")  
    
