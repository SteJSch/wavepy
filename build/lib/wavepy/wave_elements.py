class WaveAttribute:
    """
    Represents a wave attribute with a value.

    Args:
        value: Initial value of the attribute.
        name (str, optional): Name of the attribute.
    """
    def __init__(self, value=None, name=None):
        self._value = value
        self._name = name

    def set(self, value):
        self._value = value

    def get(self):
        return self._value

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
                setattr(self, attr_name, WaveAttribute(attr_value.get(), name=attr_name))
                self._children.append(getattr(self, attr_name))
    

    def children(self):
        """
        Yields the children of the WaveElement.
        """
        for child in self._children:
            yield child