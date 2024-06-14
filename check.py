import subprocess
from difflib import ndiff

def color_diff(expected, found):
    """ 
    将 found 与 expected 中不相符的部分标红
    """
    colored_found = ""
    diff = list(ndiff(expected, found))

    for i in diff:
        if i[0] == ' ':
            colored_found += i[-1]
        elif i[0] == '+': 
            colored_found += f"\033[91m{i[-1]}\033[0m"

    return colored_found

def test(data_path):
    with open(data_path, 'r') as f:
        lines = f.readlines()
    n = len(lines) // 2
    for i in range(n):
        process = subprocess.Popen(["./logic_parser.exe"], stdin=subprocess.PIPE, stdout=subprocess.PIPE, text=True)
        input = lines[i*2]
        output, _ = process.communicate(input=input)
        output = output.strip()  # 清理收到的输出
        answer = lines[i*2+1].strip()
        if answer != output:
            output = color_diff(answer, output)
            print(f"Diffence found in testcase {i + 1}:")
            print(f"Input     {input}")
            print(f"Expected  {answer}")
            print(f"Found     {output}")
            return
    print(f"Accepted!")

test("./test.txt")