import json
import os
from dotenv import load_dotenv
from typesafe_sdk import Noul, TypeSafeClient
import urllib.request

PARENT_DIR = os.path.dirname(os.getcwd())


QUESTION_TEMPLATE = os.path.join(PARENT_DIR, "jevQuestion.txt")
LESSON_LIST = os.path.join(PARENT_DIR, "handmadeHeroLessonList.txt")
OUTPUT_LIST_RAW = os.path.join(PARENT_DIR, "jevResponses.txt")
OUTPUT_LIST = os.path.join(PARENT_DIR, "relevantHHLessons.txt")

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
ABS_PARENT_DIR = os.path.dirname(SCRIPT_DIR)
ENV_PATH = os.path.join(ABS_PARENT_DIR, ".env")

load_dotenv(ENV_PATH)

API_KEY = os.environ["TYPESAFE"]


def main():

    replies = []

    with open(LESSON_LIST, "r") as f:
        for line in f:
            day_name = line[0:line.index(":")]
            with open(QUESTION_TEMPLATE, "r") as q:
                question = q.read()
            interpolated_question = question.format(lesson_id=day_name)
            print(day_name)

            instr_txt = f"is_{day_name.lower().replace(" ", "_")}_about_cs_principles" 

            data = {"state": line, "model": "jev-latest"}
            data["questions"] = {instr_txt:
                                 { "type": "noul",
                                  "instructions": interpolated_question}
                                 }
            body = json.dumps(data).encode("utf-8")

            headers = {
                    "Content-Type": "application/json",
                    "Authorization": f"Bearer {API_KEY}"
                    }

            request = urllib.request.Request(
                    "https://api.typesafe.ai/v1/systemone",
                    data=body,
                    headers=headers,
                    method="POST"
                    )

            try:
                with urllib.request.urlopen(request) as response:
                    print(response)
                    result = json.load(response)

                answer = {line: result["answers"][instr_txt]["noul"],
                          "lesson_title": line,
                          "probability": float(result["answers"][instr_txt]["noul"]) * 100
                          }

                replies.append(answer)
                with open(OUTPUT_LIST_RAW, "a") as out:
                    out.write(json.dumps(answer) + "\n")
                with open(OUTPUT_LIST, "a") as final_list:
                    if answer["probability"] > 50.0:
                        final_list.write(f"{answer['lesson_title']}")

            except Exception as error:
                print(f"ERROR: {error}")


if __name__ == "__main__":
    main()
