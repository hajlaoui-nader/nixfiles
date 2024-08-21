def hello() -> str:
    return "Hello, world!"


def goodbye() -> str:
    return "Goodbye, world!"


class Jelo:
    def __init__(self, name: str):
        self.name = name
        self.age = 0

    def say_hello(self) -> str:
        return f"Hello, {self.name}!"

    def say_goodbye(self) -> str:
        return f"Goodbye, {self.name}!"


a = Jelo("Jelo")
a.say_hello()
b = Jelo("Jelo")
b.say_goodbye()
