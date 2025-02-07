function [ resultat_difficulte ] = Difficulte()
% Specifications for the overall window holding the questionnaire:
WindowLabel = 'Evaluation de votre charge de travail';
WindowSpecs(1) = 3400;  % Left edge (i.e., pixels in from left edge of screen)
WindowSpecs(2) = 1400;  % Bottom edge (i.e., pixels up from from bottom edge of screen)
WindowSpecs(3) = 500;  % Width in pixels
WindowSpecs(4) = 190;  % Height in pixels

set(0,'PointerLocation', [3600 1500])

% Specifications for an instruction box that appears on the questionnaire:
InstructionsText = 'Instructions :\nComment définiriez-vous la difficulté à réaliser la tâche ?\n     0 : aucune difficulté\n   10 : impossible à réaliser';

InstructionHeight =70;  % This must be set to the height of the instruction box; use trial and error.

% Here are the labels (left to right on the form) of the Likert scale points.
ScaleLabels{1} = '' ;
ScaleLabels{2} = '';
ScaleLabels{3} = '';
ScaleLabels{4} = '';
ScaleLabels{5} = '';
ScaleLabels{6} = '';
ScaleLabels{7} = '';
ScaleLabels{8} = '';
ScaleLabels{9} = '';
ScaleLabels{10} = '';
ScaleLabels{11} = '';

ScaleLabelsHeight = 10;  % This must be set to the height of the scale labels; use trial and error.
ScaleSmallestValue = 0;  % The scale values are to be numbered starting with this value.

RequireAllAnswers = 1;  % Set to 1 if all questions must be answered and 0 if some can be left blank.
MissingValue = -1;  % This is the score for any question that is not answered--only used if RequireAllAnswers is 0.

Questions{1} = '';


QuestionWidth = 70;  % Width of the question on the form, in pixels
NQuestions = numel(Questions);
DefaultQuestionHeight = 30;   % This is a default question height in pixels that can be adjusted with trial and error.
QuestionHeights = DefaultQuestionHeight*ones(NQuestions); % Set all question heights to the default.
% To leave more or less height for particular questions, change their
% QuestionHeights here, after the default has been set.  For example,
% QuestionHeights(5) = DefaultQuestionHeight + 10;  % This leaves 10 extra pixels of height for question 10.

resultat_difficulte = CollectLikert(WindowSpecs,WindowLabel,InstructionsText,InstructionHeight,...
    ScaleLabels,ScaleLabelsHeight, ScaleSmallestValue, ...
    Questions, QuestionWidth, QuestionHeights, RequireAllAnswers, MissingValue)

end

