import copy

class WaveAttribute:
    """
    Represents a wave attribute with a value.

    Args:
        value: Initial value of the attribute.
        name (str, optional): Name of the attribute.
    """
    def __init__(self, value=None, name=None, wave_in_name = None,unit='',fac=None):
        self._value = value
        self.set_name(name)
        self._wave_in_name = wave_in_name
        self._unit=unit
        self._fac=fac

    def set(self, value):
        self._value = value

    def get(self):
        return self._value

    def get_fac(self):
        if self._fac is None :
            return 1
        return self._fac

    def set_name(self,name) :
        self._name = name

    def set_wave_in_name(self, wave_in_name):
        self._wave_in_name = wave_in_name

    def get_wave_in_name(self):
        return self._wave_in_name

    @property
    def name(self):
        return self._name

    def __str__(self):
        return str(self._value)

    def __repr__(self):
        return f"{self.__class__.__name__}('{self}')"

class WaveElement:
    """
    Represents a wave element with children.

    Args:
        b_type (str, optional): Type of the wave element.
    """
    def __init__(self, b_type='By'):
        self._children = []
        self._add_attributes()

    def _add_attributes(self):
        attributes = vars(self.__class__)
        for attr_name, attr_value in attributes.items():
            if isinstance(attr_value, WaveAttribute):
                attr = copy.copy(attr_value) # copy the attribute with all its attributes
                attr.set_name(attr_name) # set the name of the copy
                setattr(self, attr_name, attr) # set the copied version as the class attribute - auto setting of name attribute
                # setattr(self, attr_name, WaveAttribute(attr_value.get(), name=attr_name, wave_in_name=attr_value.get_wave_in_name()))
                self._children.append(getattr(self, attr_name))

    def children(self):
        """
        Yields the children of the WaveElement.
        """
        for child in self._children:
            yield child