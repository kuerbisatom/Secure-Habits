import 'package:app/data/data.dart';
import 'package:research_package/model.dart';

List<RPChoice> agreeChoice = [
  RPChoice(text: "5 - Strongly agree", value: 5),
  RPChoice(text: "4 - Somewhat agree", value: 4),
  RPChoice(text: "3 - Neither agree nor disagree", value: 3),
  RPChoice(text: "2 - Somewhat disagree", value: 2),
  RPChoice(text: "1 - Strongly disagree", value: 1),
  RPChoice(text: "Don't know", value: -99),
];

List<RPChoice> difficultChoice = [
  RPChoice(text: "5 - Very easy", value: 5),
  RPChoice(text: "4 - Easy", value: 4),
  RPChoice(text: "3 - Neutral", value: 3),
  RPChoice(text: "2 - Difficult", value: 2),
  RPChoice(text: "1 - Very difficult", value: 1),
  RPChoice(text: "Don't know", value: -99),
];

List<RPChoice> disruptiveChoice = [
  RPChoice(text: "5 - Not at all disruptive", value: 5),
  RPChoice(text: "4 - Slightly disruptive", value: 4),
  RPChoice(text: "3 - Fairly disruptive", value: 3),
  RPChoice(text: "2 - Disruptive", value: 2),
  RPChoice(text: "1 - Very disruptive", value: 1),
  RPChoice(text: "Don't know", value: -99),
];

List<RPChoice> likelyChoice = [
  RPChoice(text: "5 - Extremely likely", value: 5),
  RPChoice(text: "4 - Likely", value: 4),
  RPChoice(text: "3 - Neutral", value: 3),
  RPChoice(text: "2 - Unlikely", value: 2),
  RPChoice(text: "1 - Extremely unlikely", value: 1),
  RPChoice(text: "Don't know", value: -99),
];

List<RPChoice> yesNo = [
  RPChoice(text: "Yes", value: 1),
  RPChoice(text: "No", value: 0),
];

RPChoiceAnswerFormat yesNoAnswerFormat = RPChoiceAnswerFormat(
  answerStyle: RPChoiceAnswerStyle.SingleChoice,
  choices: yesNo,
);

RPChoiceAnswerFormat agreeAnswerFormat = RPChoiceAnswerFormat(
    answerStyle: RPChoiceAnswerStyle.SingleChoice, choices: agreeChoice);

RPChoiceAnswerFormat difficultAnswerFormat = RPChoiceAnswerFormat(
    answerStyle: RPChoiceAnswerStyle.SingleChoice, choices: difficultChoice);

RPChoiceAnswerFormat disruptiveAnswerFormat = RPChoiceAnswerFormat(
    answerStyle: RPChoiceAnswerStyle.SingleChoice, choices: disruptiveChoice);

RPChoiceAnswerFormat likelyAnswerFormat = RPChoiceAnswerFormat(
    answerStyle: RPChoiceAnswerStyle.SingleChoice, choices: likelyChoice);

// RPIntegerAnswerFormat weightIntegerAnswerFormat =
//     RPIntegerAnswerFormat(minValue: 0, maxValue: 200, suffix: "KG");

RPIntegerAnswerFormat minutesIntegerAnswerFormat =
    RPIntegerAnswerFormat(minValue: 0, maxValue: 1000, suffix: "minutes");

RPTextAnswerFormat textAnswerFormat =
    RPTextAnswerFormat(hintText: "Write your answer here");

RPQuestionStep additionalInfoQuestionStep = RPQuestionStep(
    identifier: 'additionalInfoQuestionStepID',
    title: 'Is there anything else you want to add?',
    answerFormat: textAnswerFormat,
    optional: true);

RPQuestionStep completeQuestionStep = RPQuestionStep(
  identifier: 'timeOfDayQuestionStepID',
  title: 'Have you successfully completed the task?',
  answerFormat: yesNoAnswerFormat,
);

RPStepJumpRule notFinishedJumpRule = RPStepJumpRule(answerMap: {
  1: finishedQuestionStep.identifier,
  0: notFinishedQuestionStep.identifier,
});

RPQuestionStep finishedQuestionStep = RPQuestionStep(
    identifier: 'dateAndTimeQuestionStepID',
    title:
        'How long did it take you to complete the task?\n(Hint: If you do not know the exact duration, you can also estimate.)',
    answerFormat: minutesIntegerAnswerFormat);

RPQuestionStep protectedQuestionStep = RPQuestionStep(
    identifier: 'dateQuestionStepID',
    title:
        'After completing the task, I feel more protected in the digital world than before.',
    answerFormat: agreeAnswerFormat);

RPQuestionStep notFinishedQuestionStep = RPQuestionStep(
  identifier: "sliderQuestionsStepID",
  title:
      "How long did you work on the task before abandoning it? \n(Hint: If you do not know the exact duration, you can also estimate.)",
  answerFormat: minutesIntegerAnswerFormat,
);

RPQuestionStep reasonsQuestionStep = RPQuestionStep(
  identifier: 'additionalQuestionStepID',
  title: 'What were the reasons you could not complete the task successfully?',
  answerFormat: textAnswerFormat,
);
RPDirectStepNavigationRule navigateToNextQuestion = RPDirectStepNavigationRule(
    destinationStepIdentifier: difficultQuestionStep.identifier);

RPQuestionStep difficultQuestionStep = RPQuestionStep(
  identifier: "questionStep1ID",
  title: "How easy was the task for you?",
  answerFormat: difficultAnswerFormat,
);

RPQuestionStep disruptiveQuestionStep = RPQuestionStep(
  identifier: "booleanQuestionStepID",
  title:
      "How disruptive do you think it would be for you to follow this behavior during your work tasks?",
  answerFormat: disruptiveAnswerFormat,
);

RPQuestionStep continueChoiceQuestionStep = RPQuestionStep(
  identifier: "instrumentChoiceQuestionStepID",
  title:
      "Regarding the behavior corresponding to the task. Would you want to continue the behavior after the study?",
  answerFormat: likelyAnswerFormat,
);

RPCompletionStep completionStep = RPCompletionStep(
    identifier: "completionID",
    title: "Finished",
    text: "Thank you for filling out the survey!");

RPInstructionStep instructionStep = RPInstructionStep(
    identifier: "instructionID",
    title: "Your Daily Survey!",
    // detailText: "For the sake of science of course...",
    text:
    'Your Daily Survey.\n\nPlease fill out the questionnaire!\nThe questions will be about the task: \n\n' +
            tasks[task]);

RPNavigableOrderedTask linearSurveyTask = RPNavigableOrderedTask(
  identifier: "surveyTaskID",
  steps: [
    instructionStep,
    completeQuestionStep,
    finishedQuestionStep,
    protectedQuestionStep,
    notFinishedQuestionStep,
    reasonsQuestionStep,
    difficultQuestionStep,
    disruptiveQuestionStep,
    continueChoiceQuestionStep,
    additionalInfoQuestionStep,
    completionStep
  ],
)
  ..setNavigationRuleForTriggerStepIdentifier(
      notFinishedJumpRule, completeQuestionStep.identifier)
  ..setNavigationRuleForTriggerStepIdentifier(
      navigateToNextQuestion, protectedQuestionStep.identifier);
