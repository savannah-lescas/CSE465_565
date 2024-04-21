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

class SimplePlace:
    """
    This class is a super class that represents a place
    with only the city and zipcode.

    Attributes:
        city (string): The city of the place.
        zipcode (int): The zipcode of the place.
    """

    def __init__(self, city = "", zipcode = 0):
        """
        Initializes a SimplePlace with the given values.

        Args:
            city (string, optional): The city of the place (default is "").
            zipcode (int, optional): The zipcode of the place (default is 0).
        """
        self._city = city
        self._zipcode = zipcode

    @staticmethod
    def get_parts(record):
        """
        Puts the city and zipcode together in a string
        separated by spaces and ending with a new line.

        Args:
            record (Place object): The record to get city 
                and zip from.
        Returns:
            str: The city and zip separated by a space with a newline.
        """
        return record.get_city() + " " + record.get_zip() + '\n'

    # override ==
    def __eq__(self, other):
        """
        Checks if the object's zipcode or city is equal
        to another's.

        Args:
            other (SimplePlace): The SimplePlace to compare with.

        Returns:
            bool: True if the zipcodes are equal or cities are equal.
            False otherwise.
        """
        return self.get_zip() == other.get_zip() or self.get_city().lower() == other.get_city().lower()
    
    # getter for city
    def get_city(self):
        """
        Returns the city.

        Returns:
            str: The city.
        """
        return self._city
    
    # setter for city
    def set_city(self, value):
        """
        Sets the value for city with a given string.

        Args:
            value (str): The new value for city.
        """
        self._city = value

    # getter for zipcode
    def get_zip(self):
        """
        Returns the zipcode.

        Returns:
            int: The zipcode.
        """
        return self._zipcode
    
    # setter for zipcode
    def set_zip(self, value):
        """
        Sets the value for zipcode with a given int.

        Args:
            value (int): The new value for zipcode.
        """
        self._zipcode = value

class Place(SimplePlace):
    """
    This class is a sub class that represents a place
    with all values.

    Attributes:
        zipcode (int): The zipcode of the place (from superclass)
        city (string): The city of the place (from superclass).
        state (str): The state of the place.
        lat (double, float, or None): The latituade of the place.
        lon (double, float, or None): The longitude of the place.
    """
    def __init__(self, zipcode, city, state, lat, lon):
        """
        Initializes a Place with the given values.

        Args:
            city (string, optional): The city of the place (default is "").
            zipcode (int, optional): The zipcode of the place (default is 0).
            state (str): The state of the place.
            lat (float, double, or None): The latitude of the place.
            lon (float, double, or None): The longitude of the place.
        """
        # initializes city and zipcode using super class
        SimplePlace.__init__(self, city, zipcode)
        self._state = state
        self._lat = lat
        self._lon = lon

    # overriding getParts from parent method
    @staticmethod
    def get_parts(record):
        """
        Puts the latitude and longitude together in a string
        separated by spaces and ending with a new line.

        Args:
            record (Place object): The record to get lat 
                and lon from.
        Returns:
            str: The lat and lon separated by a space with a newline.
        """
        return record.get_lat() + " " + record.get_lon() + '\n'

    # getter for state
    def get_state(self):
        """
        Returns the state.

        Returns:
            str: The state.
        """
        return self._state

    # setter for state
    def set_state(self, value):
        """
        Sets the value for state with a given string.

        Args:
            value (str): The new value for state.
        """
        self._state = value

    # getter for latitude
    def get_lat(self):
        """
        Returns the lat.

        Returns:
            double, float, None: The latitude.
        """
        return self._lat

    # setter for latitude
    def set_lat(self, value):
        """
        Sets the value for lat with a given input.

        Args:
            value (double, float, None): The new value for lat.
        """
        self._lat = value

    # getter for longitude
    def get_lon(self):
        """
        Returns the lon.

        Returns:
            double, float, None: The longitude.
        """
        return self._lon

    # setter for longitude
    def set_lon(self, value):
        """
        Sets the value for lon with a given input.

        Args:
            value (double, float, None): The new value for lon.
        """
        self._lon = value

# variable positional argument
def create_record(*parts):
    """
    A method that gets a variable positional argument as its input,
    if there are at least 8 arguments it will next initialize lat 
    and lon variables depending on if they are filled or not (None
    if empty), then returns a filled Place object.

    Args:
        *parts (list of strings): A variable positional argument 
        that can have any number of strings.

    Returns:
        A new, filled Place object.
    """
    if len(parts) < 8:
        return None
    # lambda function that initializes the part to 'None'
    # if there are no values
    # RealPython.com told me that None is the equivalent of null
    check_null = lambda part: part.strip() if part.strip() else None
    # lat and lon use the lambda to initialize its values
    lat = check_null(parts[6])
    lon = check_null(parts[7])
    # initialize the Place object and return it
    return Place(parts[1].strip(), parts[3].strip(), parts[4].strip(), lat, lon)

# yield
def create_place_list_yield(): 
    """
    A method that reads the zipcodes.txt file and yields
    the record that is created on the line from the 
    create_record method.

    Returns:
        Yields the record.
    """
    # opens the file
    zipcode_file = open("zipcodes.txt", "r")

    # skips the first line
    next(zipcode_file)

    # for every line in the file create the record
    # based on the line and yield it
    for line in zipcode_file:
        yield create_record(line)

    # close the file
    zipcode_file.close()

def create_place_list():
    """
    A method that returns a list of all the Place objects 
    by using the create_record method on the list of parts
    from each line of the zipcodes.txt file.

    Returns:
        place_list: A list of all Place objects created 
        from the lines in zipcodes.txt.
    """
    # use map to apply a function to the lines
    # from the file
    place_list = []
    zipcode_file = open("zipcodes.txt", "r")

    # skip first line
    next(zipcode_file)

    # since the line could have different numbers
    # of elements, we use a variable positional 
    # argument
    # uses map to add to the place list with the
    # create_record function on each line from 
    # the zipcode file
    place_list.extend(map(lambda line: create_record(*line.split('\t')), zipcode_file))

    zipcode_file.close()

    return place_list


def common_city_names(place_list):
    """
    A method that reads through the states from states.txt,
    stores them as keys in state_city_dict, then goes through
    every Place object and adds the city name to the set of 
    values to the particular state if it is a key in the 
    dictionary, then goes through every value checking for
    city names that are common to both of the states.

    Args:
        place_list: The list of Place objects.
    """
    state_city_dict = {}

    with open("states.txt", "r") as states:
        # add the states as keys to the dictionary
        for state in states:
            state = state.strip()
            # check if the line is not empty
            if state: 
                state_city_dict[state] = set()

        # go through every place object
        for place in place_list:
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

    with open("ComonCityNames.txt", "w") as output_file:
        for city in common_cities:
            output_file.write(city + '\n')

# another method using yield in case the other one doesn't
# count
def lat_lon_yield(place_list):
    """
    A method that goes through the given zips.txt file
    and compares the zipcodes from the file to all the
    zipcodes in place_list and if they are equal checks 
    if there are values in the lat lon spot, if not 
    continues to check to find filled lat lon values
    and once it does it yields the string of lat and
    lon string from the get_parts method of the Place
    class and then stops searching for that zipcode's 
    lat and lon values and continues on with the loop.

    Args:
        place_list: the list of all records.

    Returns:
        yields the lat and lon in string form.
    """
    # reads the zips.txt file to read from
    with open("zips.txt", "r") as zips:
        # for every zipcode in zips.txt
        for zip in zips:
            # create the SimplePlace object with the zip
            simple_zip = SimplePlace("", zip.strip())
            # go through every record in placeList
            for record in place_list:
                # use the overrided == method to check if the
                # zipcodes match
                if simple_zip == record:
                    # if they match but the latitude or longitude is 'None'
                    # keep looking
                    if record.get_lat() == None or record.get_lon() == None:
                        continue
                    # otherwise, write the latitude and longitude to the
                    # LatLon.txt file separated by a space
                    else:
                        yield(Place.get_parts(record))
                        break

def write_to_lat_lon(place_list):
    """
    A method that takes the yields from lat_lon_yield
    and prints them to LatLon.txt.

    Args:
        place_list: list of all the records.
    """
    with open("LatLon.txt", "w") as lat_lon_file:
        for lat_lon in lat_lon_yield(place_list):
            lat_lon_file.write(lat_lon)

def lat_lon(place_list):
    """
    A method that reads the zips.txt file and for each 
    zipcode in there, it searches for the record that has
    a matching zipcode, and if it does checks that it is
    not 'None' and then prints it to the LatLon.txt file
    only once.

    Args:
        place_list: The list of Place objects. 
    """
    # opens the new file to write to
    lat_lon_file = open("LatLon.txt", "w")
    # reads the zips.txt file to read from
    with open("zips.txt", "r") as zips:
        # for every zipcode in zips.txt
        for zip in zips:
            # create the SimplePlace object with the zip
            simple_zip = SimplePlace("", zip.strip())
            # go through every record in placeList
            for record in place_list:
                # use the overrided == method to check if the
                # zipcodes match
                if simple_zip == record:
                    # if they match but the latitude or longitude is 'None'
                    # keep looking
                    if record.get_lat() == None or record.get_lon() == None:
                        continue
                    # otherwise, write the latitude and longitude to the
                    # LatLon.txt file separated by a space
                    else:
                        lat_lon_file.write(Place.get_parts(record))
                        break
    # close LatLon.txt
    lat_lon_file.close()

def city_states(place_list):
    """
    A method that reads through cities.txt, and for each city
    in the file, and checks every state to see if it has that
    city name, if it does add it to a list then append the list
    to the file on a line.

    Args:
        place_list: The list of Place objects.
    """
    # open the files for reading and writing
    in_file = open("cities.txt", "r")
    out_file = open("CityStates.txt", "w")

    for city in in_file:
        # creates a list for the states that share the city name
        states = []
        # strips the city name from the file
        stripped_city = city.strip()
        # creates a SimplePlace object to use the == operator
        simple_city = SimplePlace(stripped_city, 0)
        # list comprehension
        states = sorted(set([record.get_state() for record in place_list if record == simple_city]))

        # write the states to the file
        for state in states:
            out_file.write(state + " ")

        out_file.write('\n')
        
    in_file.close()
    out_file.close()


if __name__ == "__main__": 
    start_time = time.perf_counter()  # Do not remove this line
    '''
    Inisde the __main__, do not add any codes before this line.
    -----------------------------------------------------------
    '''

    # create the place list
    place_list = create_place_list()
    # call all the methods to perform tasks
    common_city_names(place_list)
    lat_lon(place_list)
    city_states(place_list)


    '''
    Inside the __main__, do not add any codes after this line.
    ----------------------------------------------------------
    '''
    end_time = time.perf_counter()
    # Calculate the runtime in milliseconds
    runtime_ms = (end_time - start_time) * 1000
    print(f"The runtime of the program is {runtime_ms} milliseconds.")  
    
