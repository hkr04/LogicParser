import subprocess
from difflib import ndiff

def color_diff(expected, found):
    """ 
    将 found 与 expected 中不相符的部分标红
    """
    colored_expected = ""
    colored_found = ""
    diff = list(ndiff(expected, found))

    for i in diff:
        if i[0] == ' ':
            colored_expected += i[-1]
            colored_found += i[-1]
        elif i[0] == '-':
            colored_expected += f"\033[92m{i[-1]}\033[0m"
        elif i[0] == '+': 
            colored_found += f"\033[91m{i[-1]}\033[0m"

    return colored_expected, colored_found

def test(input_path, answer_path):
    with open(input_path, 'r') as f:
        inputs = f.read()
        f.close()
    with open(answer_path, 'r') as f:
        answers = f.readlines()
        f.close()
    process = subprocess.Popen(["./logic_parser.exe"], 
                               stdin=subprocess.PIPE, 
                               stdout=subprocess.PIPE, 
                               text=True)
    outputs, _ = process.communicate(input=inputs)
    inputs = inputs.split('\n')
    outputs = outputs.split('\n')
    accepted = True
    for i, (input, answer, output) in enumerate(zip(inputs, answers, outputs)):
        answer = answer.strip()
        output = output.strip()
        if answer != output:
            accepted = False
            answer, output = color_diff(answer, output)
            print(f"Diffence found in testcase {i + 1}:")
            print(f"Input     {input}")
            print(f"Expected  {answer}")
            print(f"Found     {output}")
    if accepted:
        print(f"\033[92mAccepted!\033[0m")

test("./test.in", "./test.ans")