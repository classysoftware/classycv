% ABOUT A LaTeX2e class for writing classy job applications. 
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{classycv}[2016/12/21 A LaTeX2e class for writing classy job applications.]

% HREF http://stackoverflow.com/a/587054
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions
\LoadClass{article}

% % % % % % % % 
% DEPENDENCIES %
% % % % % % % % 

% NOTE For `\DeclareUnicodeCharacter`
\RequirePackage[utf8]{inputenc}
\RequirePackage{pgfkeys}
\RequirePackage[%
	% This parameter has to be set in order for `\loadgeometry` to actually change the layout.
	pass%
	, margin=0pt%
  	%!, showframe%
]{geometry}
\RequirePackage{titleps}
\RequirePackage{tikz}
\RequirePackage{pdftexcmds}
\RequirePackage{environ}
% NOTE for maximum width nodes
% HREF http://tex.stackexchange.com/a/46479
\RequirePackage{varwidth}
% NOTE Minipage like environment with customizable left and right margins
% HREF http://tex.stackexchange.com/a/32707
\RequirePackage{changepage}
% NOTE For `\getpagerefnumber` (extract number values from page labels).
\RequirePackage{refcount}
% NOTE For `\adjustbox` and `\marginbox`
% HREF http://tex.stackexchange.com/a/28638
\RequirePackage{adjustbox}
\RequirePackage{tabularx}
\RequirePackage{color}
% NOTE For cover letter icons.
\RequirePackage{marvosym}
% NOTE For `\href`.
\RequirePackage[hidelinks]{hyperref}
% NOTE For `\colorlet` as well as colored table rows and columns (option `table`).
\RequirePackage{xcolor}
% NOTE For `\includegraphics`.
\RequirePackage{graphicx}
% NOTE For `\tcbox`.
\RequirePackage{tcolorbox}
% NOTE For symbols.
\RequirePackage{textcomp}
% NOTE For `H` parameter in figure environments.
\RequirePackage{float}
% NOTE For symbols.
\RequirePackage{fontawesome}
% NOTE For `\DeclareDocumentCommand`.
\RequirePackage{xparse}
% NOTE For `\StrSplit`
\RequirePackage{xstring}
% NOTE For `\includepdf`
\RequirePackage{pdfpages}
% NOTE For Lato font.
\RequirePackage{lato}
% NOTE For Roboto font.
\RequirePackage{roboto}
% NOTE For Computer Modern Bright font.
\RequirePackage{cmbright}
% NOTE For Latin Modern font.
\RequirePackage{lmodern}
% NOTE For Bytestream Vera font.
\RequirePackage{bera}
% NOTE For `\larger` and `\smaller`.
\RequirePackage{relsize}
% NOTE For `\LetLtxMacro`
% HREF http://tex.stackexchange.com/a/116705
\RequirePackage{letltxmacro}
% NOTE For boolean macros and `\ifthenelse`.
\RequirePackage{ifthen}

% % % % % % % 
% VARIABLES %
% % % % % % %

\providecommand{\classycv@arguments}{}

% NOTE General purpose length registers.
\newlength{\classycv@@lI}
\setlength{\classycv@@lI}{0pt}

\newlength{\classycv@@lII}
\setlength{\classycv@@lII}{0pt}

\newlength{\classycv@@lIII}
\setlength{\classycv@@lIII}{0pt}

\newlength{\classycv@@lIV}
\setlength{\classycv@@lIV}{0pt}

% NOTE General purpose counter registers.
\newcounter{classycv@@cI}
\setcounter{classycv@@cI}{0}

\newcounter{classycv@@cII}
\setcounter{classycv@@cII}{0}

% NOTE Copy of default `\parindent` length.
\newlength{\classycv@parindent@default}
\setlength{\classycv@parindent@default}{\parindent}

% NOTE Copy of default `\parskip` length.
\newlength{\classycv@parskip@default}
\setlength{\classycv@parskip@default}{\parskip}

% NOTE Copy of default `\baselineskip` length.
\newlength{\classycv@baselineskip@default}
\setlength{\classycv@baselineskip@default}{\baselineskip}

% NOTE Copy of default `\tabcolsep` length.
\newlength{\classycv@tabcolsep@default}
\setlength{\classycv@tabcolsep@default}{\tabcolsep}

% NOTE Cover letter counter.
\newcounter{classycv@coverLetterCounter}
\setcounter{classycv@coverLetterCounter}{0}

% NOTE Cover letter page counter.
\newcounter{classycv@coverLetterPageCounter}

% NOTE Attachment counter.
\newcounter{classycv@attachmentCounter}
\setcounter{classycv@attachmentCounter}{0}

% NOTE General purpose boolean register.
\newboolean{classycv@@bI}
\setboolean{classycv@@bI}{false}

% NOTE Cover letter environment flag (used to prevent nested cover letter environments).
\newif\ifcoverletter
	\coverletterfalse
	
% NOTE Resume environment flag (used to prevent nested resume environments).
\newif\ifresume
	\resumefalse

% % % % % % 
% COMMANDS %
% % % % % % 

% NOTE Font selection.
\newcommand{\cmrfamily}{\fontfamily{cmr}\selectfont}
\newcommand{\lmrfamily}{\fontfamily{lmr}\selectfont}
\newcommand{\cmbrfamily}{\fontfamily{cmbr}\selectfont}
\renewcommand{\robotofamily}{\fontfamily{Roboto-LF}\selectfont}
\newcommand{\berafamily}{\fontfamily{fve}\selectfont}

\makeatletter

% NOTE Intersperse all characters within the second given string with the first given string.
\newcommand{\classycv@intersperse}[2]{%
	% This should not be reached.
	\ifnum\pdf@strcmp{#2}{\@empty}=\z@%
	\else%
		% Split at the first character.
		\StrSplit{#2}{1}{\classycv@a}{\classycv@b}%
		% Last character?
		\ifnum\pdf@strcmp{\classycv@b}{\@empty}=\z@%
			% Yes: put last character.
			\classycv@a%
		\else%
			% No: intersperse and continue.
			\classycv@a#1\classycv@intersperse{#1}{\classycv@b}%
		\fi%
	\fi%
}

%%
% Wrap the given argument in a circle.
%
% #1: (optional) Tikz arguments.
% #2: (mandatory) Text to be wrapped.
%%
\newcommand{\classycv@DrawCircle}[2][]{%
	% Were optional arguments given?
	\pgfkeys{/classycv/data/draw circle/options/.cd, #1}%
	\pgfkeys{%
		/classycv/data/draw circle/options/.cd%
		, height/.get=\height%
		, border width/.get=\borderWidth%
		, border color/.get=\borderColor%
		, background color/.get=\bg%
		, text color/.get=\textColor%
		, padding/.get=\padding%
	}%
	\edef\@@bg{\ifnum\pdf@strcmp{\@empty}{\bg}=\z@ none\else\bg\fi}%
	% Calculate text height/text width, depth and radius.
	\setlength{\classycv@@lI}{\dimexpr\height-\dimexpr\padding+\padding\relax-\dimexpr\borderWidth+\borderWidth\relax\relax}%
	\setlength{\classycv@@lII}{\dimexpr0.34\height\relax}%
	\setlength{\classycv@@lIII}{\dimexpr0.5\dimexpr\height-\dimexpr\borderWidth+\borderWidth\relax}%
	\setlength{\classycv@@lIV}{\dimexpr\borderWidth\relax}
	% Shift the circled text down s.t. the circled text's base line and the text base line are aligned.
	\adjustbox{raise=-\classycv@@lII, height=\height, margin=0, padding=0}{%
		\tikz {%
			\draw[%
				use as bounding box%
				, inner sep=0pt%
				, outer sep=0pt%
				, draw=none%
				% DEBUG uncomment to see border of bounding box.
				%!, draw=black%
			] rectangle (\height, \height);%
			% TODO centering is not perfect.
			\draw[line width=\borderWidth, draw=\borderColor, fill=\@@bg] (current bounding box.center) circle (\classycv@@lIII);%
			% DEBUG uncomment to see text node baseline.
			%!, \draw[draw=red] (0, \classycv@@lII) rectangle (\height, \classycv@@lII);%
			\node[%
				, below right=\classycv@@lIV and \classycv@@lIV of current bounding box.north west% 
				, inner sep=\padding%
				, outer sep=0pt%
				, draw=none%
				% DEBUG uncomment to see border of text node.
				%!, draw=green%
				, align=center%
				, text width=\classycv@@lI%
				, text depth=\dimexpr0.34\classycv@@lI\relax%\classycv@@lI\relax%\dimexpr\classycv@@lII\relax%
				, text height=\dimexpr0.66\classycv@@lI\relax%\classycv@@lI\relax%\dimexpr0.66\classycv@@lI\relax%
			] {%
				\ifnum\pdf@strcmp{\@empty}{\textColor}=\z@\else\expandafter\color\expandafter{\textColor}\fi{#2}%
			}%
		}%
	}%
}

%%
% Wrap the given argument in a hexagon.
%
% #1: (optional) Tikz arguments.
% #2: (mandatory) Text to be wrapped.
%%
\newcommand{\classycv@wrapWithHexagon}[2][]{%
	% Were optional arguments given?
	\ifnum\pdf@strcmp{#1}{\@empty}=\z@%
		% No: don't pass to node.
		\tikz[baseline=(text.base)]{\node[inner sep=1pt, regular polygon, regular polygon sides=6, draw, thick, color=light-gray] (text) {#2};}
	\else%
		% Yes: pass to node.
		\tikz[baseline=(text.base)]{\node[inner sep=1pt, regular polygon, regular polygon sides=6, draw, thick, color=light-gray, #1] (text) {#2};}
	\fi%
}

%%
% Test if the parameter expands to a zero width box 
% 
% #1: (mandatory) Command or text to be tested.
% 
% HREF http://tex.stackexchange.com/a/42284
% TODO deprecated?
%%
\newcommand{\classycv@producesEmpty}[1]{%
  \sbox0{#1}%
  \ifdim\wd0=0pt%
    \numexpr1%
  \else%
  	\numexpr0%
  \fi%
}

% NOTE Color definitions.
\definecolor{nearly-black}{RGB}{10, 10, 10}
\definecolor{nearly-white}{RGB}{245, 245, 245}
\definecolor{light-gray}{RGB}{200, 200, 200}
\definecolor{medium-gray}{RGB}{127, 127, 127}
\definecolor{dark-gray}{RGB}{55, 55, 55}
\definecolor{accent-color}{RGB}{48, 84, 128}
\definecolor{highlight-color}{RGB}{140, 190, 233}

% NOTE Constants.
\newcommand{\classycv@FORMAT@COVERLETTER@DINLETTERA}{din-5008-a}
\newcommand{\classycv@FORMAT@COVERLETTER@USBLOCK}{us-block}
\newcommand{\classycv@FORMAT@RESUME@CLASSIC}{classic}
\newcommand{\classycv@FORMAT@RESUME@MODERN}{modern}

% NOTE Public interface.

%%
% Set classycv data.
%
% #1: (mandatory) Key (a pgfkeys path; must be prefixed with `/').
% #2: (mandatory) Value
%%
\providecommand{\classycvSet}[2]{\pgfkeyssetvalue{/classycv/data#1}{#2}}

%%
% Get classycv data.
%
% #1: (mandatory) Key (a pgfkeys path; must be prefixed with `/').
% #2: (mandatory) The macro to store the value in.
%%
\providecommand{\classycvGet}[2]{\pgfkeysvalueof{/classycv/data#1}}

%%
% Clear classycv data.
%
% #1: (mandatory) Key (a pgfkeys path; must be prefixed with `/').
% #2: (mandatory) The macro to store the value in.
%
% TODO shouldn't this have only one parameter?
%%
\providecommand{\classycvClear}[2]{\pgfkeyssetvalue{/classycv/data#1}{\@empty}}

%%
% Define a component.
%
% #1: (mandatory) Key (a pgfkeys path; must be prefixed with `/').
% #2: (mandatory) The component definition or command expanding to the component.
%%
\providecommand{\classycvDefineComponent}[2]{%
	\@namedef{/classycv/components#1}{#2}%
}

%%
% Cover letter environment.
%
% #1: (optional) Cover letter environment options.
% #2: (mandatory) Submitter information.
% #3: (mandatory) Recipient information.
% #4: (mandatory) Subject line.
% #5: (mandatory) Opening line.
% #6: (mandatory) Closing line.
% 
% TODO optional parameter
%%
\newenvironment{CoverLetter}[6][]{%
	% Check if this was called within a cover letter environment.
	\ifcoverletter\errmessage{Terminal error: detected invalid nested cover letter environment}\else\fi%
	\coverlettertrue%
	% Increase the cover letter counter.
	\stepcounter{classycv@coverLetterCounter}%
	% Reset the cover letter page counter.
	\setcounter{classycv@coverLetterPageCounter}{0}%
	% Label the first page.
	\label{cover-letter-\theclassycv@coverLetterCounter-first-page}%
	% Switch for letter format.
	\pgfkeys{/classycv/data/settings/cover letter/format/.get=\classycv@format}%
	\ifnum\pdf@strcmp{\classycv@format}{\classycv@FORMAT@COVERLETTER@DINLETTERA}=\z@%
		% DIN 5008 A format.
		\begin{classycv@PutCoverLetterDINLetterA}[#1]{#2}{#3}{#4}{#5}{#6}%
	\else\ifnum\pdf@strcmp{\classycv@format}{\classycv@FORMAT@COVERLETTER@USBLOCK}=\z@%
		% US business letter block format
		\begin{classycv@PutCoverLetterUsBlock}[#1]{#2}{#3}{#4}{#5}{#6}%
	\else%
		% Invalid letter format.
		\ClassWarning{classycv}{(!) undefined letter format (\classycv@format)}%
	\fi\fi%
}{%
	% Close cover letter environment.
	\pgfkeys{/classycv/data/settings/cover letter/format/.get=\classycv@format}%
	\ifnum\pdf@strcmp{\classycv@format}{\classycv@FORMAT@COVERLETTER@DINLETTERA}=\z@%
		\end{classycv@PutCoverLetterDINLetterA}%
	\else\ifnum\pdf@strcmp{\classycv@format}{\classycv@FORMAT@COVERLETTER@USBLOCK}=\z@%
		\end{classycv@PutCoverLetterUsBlock}%
	\fi\fi%
	% Label the last page (to be able to calculate the page count).
	\label{cover-letter-\theclassycv@coverLetterCounter-last-page}%
	% Reset cover letter flag.
	\coverletterfalse%
}

%%
% Resume environment.
%
% #1: (optional) Resume environment options.
% #2: (mandatory) Personal data.
%%
\newenvironment{Resume}[2][]{%
	% Check if this was called within a resume environment.
	\ifresume\errmessage{Terminal error: detected invalid nested resume environment}\else\fi%
	\resumetrue%
	% Define aliases for resume components.
	\LetLtxMacro\circle\classycv@DrawCircle%
	\LetLtxMacro\semicircle\classycv@PutSemicircle%
	\LetLtxMacro\doughnut\classycv@PutDoughnutChart%
	\LetLtxMacro\progress\classycv@PutProgressBar%
	\LetLtxMacro\heading\classycv@PutHeading%
	\LetLtxMacro\bar\classycv@PutBar%
	\LetLtxMacro{\Table}\classycv@PutTable%
	\LetLtxMacro{\endTable}\endclassycv@PutTable%
	\LetLtxMacro{\Entry}\classycv@PutResumeEntry%
	\LetLtxMacro{\endEntry}\endclassycv@PutResumeEntry%
	\LetLtxMacro{\List}\classycv@PutList%
	\LetLtxMacro{\endList}\endclassycv@PutList%
	% Switch for resume format.
	\pgfkeys{/classycv/data/settings/resume/format/.get=\classycv@format}%
	\ifnum\pdf@strcmp{\classycv@format}{\classycv@FORMAT@RESUME@CLASSIC}=\z@%
		% Classic resume format.
		\begin{classycv@PutResumeClassic}[#1]{#2}%
	\else%
	\ifnum\pdf@strcmp{\classycv@format}{\classycv@FORMAT@RESUME@MODERN}=\z@%
		% Modern resume format.
		\begin{classycv@PutResumeModern}[#1]{#2}%
	\else%
		% Invalid resume format.
		\ClassWarning{classycv}{! undefined letter format (\classycv@format)}%
	\fi\fi%
}{%
	% Close resume environment.
	\pgfkeys{/classycv/data/settings/resume/format/.get=\classycv@format}%
	\ifnum\pdf@strcmp{\classycv@format}{\classycv@FORMAT@RESUME@CLASSIC}=\z@%
		% Classic resume format.
		\end{classycv@PutResumeClassic}%
	\else
	\ifnum\pdf@strcmp{\classycv@format}{\classycv@FORMAT@RESUME@MODERN}=\z@%
		% Modern resume format.
		\end{classycv@PutResumeModern}%
	\fi\fi%
	% Reset resume flag.
	\resumefalse%
}

%%
% Draw a single or multiple page attachment using `includepdf`.
%
% #1: (optional) Attachment data.
% #2: (optional) Attachment command options.
% #3: (optional) `includepdf` options.
% #4: (mandatory) attachment file path.
%%
\DeclareDocumentCommand{\attachment}{O{} O{} O{} m}{%
	\bgroup%
	% Increase attachment counter and label first page.
	\stepcounter{classycv@attachmentCounter}%
	\label{attachment-\theclassycv@attachmentCounter-first-page}%
	% Set attachment data.
	\ifnum\pdf@strcmp{\@empty}{#1}=\z@\else\pgfkeys{/classycv/data/attachment/.cd, #1}\fi%
	\ifnum\pdf@strcmp{\@empty}{#2}=\z@\else\pgfkeys{/classycv/data/attachment/options/.cd, #2}\fi%
	% Define default components.
	\@ifundefined{/classycv/components/attachment/footer}{\classycvDefineComponent{/attachment/footer}{\classycv@attachment@footerComponent}}{}%
	% Set page geometry.
	\pagestyle{attachment}%
	\loadgeometry{attachment}%
	\clearpage%
	% Calculate pdf height.
	\setlength{\classycv@@lI}{\dimexpr\textheight-\classycv@GEOMETRY@ATTACHMENT@FOOTERHEIGHT}%
	% Were PDF options passed?
	\ifnum\pdf@strcmp{#3}{\@empty}=\z@%
		% No: don't pass to `includepdf`.
		\includepdf[height=\classycv@@lI, keepaspectratio, pages={1-}, pagecommand={\pagestyle{attachment}}]{#4}%
	\else%
		% Yes: pass to `includepdf`.
		\includepdf[height=\classycv@@lI, keepaspectratio, pages={1-}, pagecommand={\pagestyle{attachment}}, #3]{#4}%
	\fi%
	% Label last page (to be able to calculate the attachment page count).
	\label{attachment-\theclassycv@attachmentCounter-last-page}%
	\egroup%
}

% NOTE private interface

%%
% Draw the component for the given identifier.
%
% #1: (mandatory) Component identifier (must be a pgfkeys path prefixed with `/').
%%
\providecommand{\classycv@PutComponent}[1]{%
	\bgroup%
	% Draw component if not undefined.
	\@ifundefined{/classycv/components#1}{%
		\ClassWarning{classycv}{missing component ``#1''}%
	}{%
		\csname/classycv/components#1\endcsname%
	}%
	\egroup%
}

%%
% Draw a simple horizontal bar.
%
% #1: (optional) Command options.
% #2: (mandatory) Bar color.
%%
\providecommand{\classycv@PutBar}[2][]{%
	\bgroup%
	\pgfkeys{/classycv/data/put bar/options/.cd, #1}%
	\pgfkeys{%
		/classycv/data/put bar/options/.cd%
		, width/.get=\width%
		, height/.get=\height%
		, strength/.get=\strength%
		, skip above/.get=\skipAbove%
		, skip below/.get=\skipBelow%
	}%	
	\ifdim\skipAbove=0pt\else\vspace*{\skipAbove}\par\fi%
	\tikz{
		\draw[use as bounding box, draw=none, inner sep=0pt] rectangle (\width, \height);%
		\path[draw, line width=\strength, color=#2] (current bounding box.west) -- (current bounding box.east);%
	}%
	\ifdim\skipBelow=0pt\par\else\vspace*{\skipBelow}\par\fi%
	\egroup%
}

%%
% Draw a simple horizontal progress bar.
%
% #1: (optional) Command options.
% #2: (mandatory) Completion percentage.
%
% TODO progress bar is not properly aligned if a non-zero border is specified.
%%
\providecommand{\classycv@PutProgressBar}[2][]{%
	\bgroup%
	\pgfkeys{/classycv/data/put progress bar/options/.cd, #1}%
	\pgfkeys{%
		/classycv/data/put progress bar/options/.cd%
		, height/.get=\height%
		, background color/.get=\backgroundColor%
		, foreground color/.get=\foregroundColor%
		, border width/.get=\borderWidth%
		, border color/.get=\borderColor%
		, width/.get=\width%
		, has label/.get=\hasLabel%
		, label width/.get=\labelWidth%
		, label position/.get=\labelPosition%
		, label font/.get=\labelFont%
		, label color/.get=\labelColor%
		, label text/.get=\labelText%		
		, label text align/.get=\labelTextAlign%
		, skip between/.get=\skipBetween%
	}%
	% Calculate the width and height of the progress bar foreground (the visible completion).
	\setlength{\classycv@@lI}{\width}%
	\divide\classycv@@lI by 100\relax%
	\multiply\classycv@@lI by #2\relax%
	\setlength{\classycv@@lII}{\height-\dimexpr\borderWidth\relax}
	\begin{tikzpicture}%
		\ifnum\pdf@strcmp{yes}{\hasLabel}=\z@%
			\ifnum\pdf@strcmp{left}{\labelPosition}=\z@%
				\begin{pgfonlayer}{background}%
					\node[%
						anchor=north west%
						, minimum width=\labelWidth%
						, minimum height=\height%
						, text width=\labelWidth%
						, inner sep=0pt%
						, outer sep=0pt%
						, font=\labelFont%
						, text=\labelColor%
						, align=\labelTextAlign] (label) {\labelText};%
					\coordinate (P1) at ($([shift={(\skipBetween, 0)}]label.south east)$);%
					\draw[text width=, line width=\borderWidth, draw=\borderColor, fill=\backgroundColor] (P1) rectangle +(\width, \height);%
				\end{pgfonlayer}%
				\begin{pgfonlayer}{main}%
					\coordinate (P2) at ($([shift={(\skipBetween + \borderWidth, \borderWidth)}]label.south east)$);%
					\draw[draw=none, fill=\foregroundColor] (P2) rectangle +(\classycv@@lI, \classycv@@lII);%
				\end{pgfonlayer}%
			\else%
				\begin{pgfonlayer}{background}%
					\draw[text width=, line width=\borderWidth, draw=\borderColor, fill=\backgroundColor] (0, 0) rectangle +(\width, \height);%
					\coordinate (P1) at (\width, 0);%
					\coordinate (P2) at ($([shift={(\skipBetween, 0)}]P1.south east)$);%
					\node[%
						above right=0pt and 0pt of P2%
						, minimum width=\labelWidth%
						, minimum height=\height%
						, text width=\labelWidth%
						, inner sep=0pt%
						, outer sep=0pt%
						, font=\labelFont%
						, text=\labelColor%
						, align=\labelTextAlign] (label) {\labelText};%
				\end{pgfonlayer}%
				\begin{pgfonlayer}{main}%
					\draw[draw=none, fill=\foregroundColor] (\borderWidth, \borderWidth) rectangle +(\classycv@@lI, \classycv@@lII);%
				\end{pgfonlayer}%
			\fi%
		\else%
			\begin{pgfonlayer}{background}%
				\draw[text width=, line width=\borderWidth, draw=\borderColor, fill=\backgroundColor] (0, 0) rectangle +(\width, \height);%
			\end{pgfonlayer}%
			\begin{pgfonlayer}{main}%
				\draw[draw=none, fill=\foregroundColor] (\borderWidth, \borderWidth) rectangle +(\classycv@@lI, \classycv@@lII);%
			\end{pgfonlayer}%
		\fi%
	\end{tikzpicture}%
	\egroup%
}

%%
% Draw a semi circle.
%
% #1: (optional) Command options.
% #2: (mandatory) Completion percentage x (x = 0,...,100).
%
% HREF: http://tex.stackexchange.com/a/15983
%%
\providecommand{\classycv@PutSemicircle}[2][]{%
	\bgroup%
	\pgfkeys{/classycv/data/put semicircle/options/.cd, #1}%
	\pgfkeys{%
		/classycv/data/put semicircle/options/.cd%
		, size/.get=\size%
		, strength/.get=\strength%
		, line color/.get=\lineColor%
		, fill color/.get=\fillColor%
		, has label/.get=\hasLabel%
		, label text/.get=\labelText%
		, label font/.get=\labelFont%
		, label color/.get=\labelColor%
		, draw complement/.get=\drawComplement%
		, complement line color/.get=\complementLineColor%
		, draw glow/.get=\drawGlow%
	}%
	\tikz{%	
		\pgfmathsetmacro\arcLength{(#2/100)*360}%
		\pgfmathsetmacro\endDegree{Mod(\arcLength, 360)}%
		% Normalize to 360 degrees if `\arcLength` is any multiple of 360 greater than 0.
		\ifnum0 = \endDegree\relax%
			\ifnum0 < #2\relax%
				\pgfmathsetmacro\endDegree{360}%
			\fi%
		\fi%
		\setlength{\classycv@@lI}{\dimexpr0.5\size\relax}%
		\begin{pgfonlayer}{main}
		    \draw[use as bounding box, draw=\lineColor, fill=\fillColor, rotate=270, line width=\strength] (0, 0) arc (0:\endDegree:\size);%
		\end{pgfonlayer}{main}
		% Draw a glow effect?
		\ifnum\pdf@strcmp{yes}{\drawGlow}=\z@%
			\begin{pgfonlayer}{background}
			    \draw[draw=none, fill=none, circular glow={fill=light-gray!50!nearly-white}, rotate=270] (0, 0) arc (0:360:\size);%
			\end{pgfonlayer}%
		\fi%
		% Draw complement?
		\ifnum\pdf@strcmp{yes}{\drawComplement}=\z@%
			\begin{pgfonlayer}{overlay 1}
				\draw[draw=\complementLineColor, fill=\fillColor, line width=\strength, rotate=270] (0, 0) arc (360:\endDegree:\size);			
		    \end{pgfonlayer}%
		\fi%
		% Draw label?
		\ifnum\pdf@strcmp{yes}{\hasLabel}=\z@%
			\begin{pgfonlayer}{overlay 2}%
			    \node[draw=none, minimum size=\size, text width=, text=\labelColor, font=\labelFont] at (current bounding box.center) {\labelText};%
			\end{pgfonlayer}
		\fi%
	}%
	\egroup%
}

%%
% Draw a doughnut chart.
%
% #1: (optional) Command options.
% #2: (mandatory) Completion percentage (a CSV list of entries with syntax `<label>/<percentage>/color' containing the specification of the doughnut's sectors).
%
% HREF https://tex.stackexchange.com/a/66219
% EXAMPLE \classycv@PutDoughnutChart[strength=12pt]{1/20/blue!50,2/20/blue!40,3/25/blue!30,4/35/blue!20}
%%
\providecommand{\classycv@PutDoughnutChart}[2][]{%
	\pgfkeys{/classycv/data/put doughnut chart/options/.cd, #1}%
	\pgfkeys{%
		/classycv/data/put doughnut chart/options/.cd%
		, size/.get=\size%
		, strength/.get=\strength%
		, line color/.get=\lineColor%
		, label size/.get=\labelSize%
		, label shape/.get=\labelShape%
		, label line color/.get=\labelLineColor%
		, label fill color/.get=\labelFillColor%
		, label text color/.get=\labelTextColor%
		, basic style/.get=\basicStyle%
	}%
	\setcounter{classycv@@cI}{0}% arc start
	\setcounter{classycv@@cII}{0}% arc end
	\begin{tikzpicture}[%
		extended line/.style={shorten >=-##1,shorten <=-##1}
		, extended line/.default=1cm
		, right extended line/.style={shorten >=-##1}
		, right extended line/.default=1cm
	]%
		\draw[draw=none, use as bounding box, inner sep=0pt, outer sep=0pt] rectangle (\size, \size);
		\foreach \x [count=\i] in {#2} {%
			\StrCut{\x}{/}\label\r%
			\StrCut{\r}{/}\percentage\lineColor%
			\setcounter{classycv@@cI}{0}%
			\addtocounter{classycv@@cI}{\theclassycv@@cII}%
			\setcounter{classycv@@cII}{\numexpr 360 *\percentage/100\relax}%
			\setcounter{classycv@@cII}{\numexpr\theclassycv@@cI + \theclassycv@@cII}%
			\draw[\lineColor, line width=\strength] ([shift=(\theclassycv@@cI:\dimexpr0.5\dimexpr\size-\strength\relax)]\dimexpr0.5\size\relax,\dimexpr0.5\size\relax) arc (\theclassycv@@cI:\theclassycv@@cII:\dimexpr0.5\dimexpr\dimexpr\size-\strength\relax) coordinate[below, midway] (P\i); 
			\node[below right=-0.5em and -0.5em of P\i, text width=\labelSize, align=center, inner sep=0pt, outer sep=0pt, \labelShape, draw=\labelLineColor, fill=\labelFillColor, text=\labelTextColor] {\basicStyle\label};
	};%
	\end{tikzpicture}%
}

%%
% Draw a simple heading.
%
% #1: (optional) Command options.
% #2: (mandatory) Heading text.
%%
\providecommand{\classycv@PutHeading}[2][]{%
	\bgroup%
	\pgfkeys{/classycv/data/put heading/options/.cd, #1}%
	\pgfkeys{%
		/classycv/data/put heading/options/.cd%
		, width/.get=\width%
		, height/.get=\height%
		, border width/.get=\borderWidth%
		, border color/.get=\borderColor%
		, sharp corners/.get=\sharpCorners%
		, foreground color/.get=\fg%
		, background color/.get=\bg%
		, basic style/.get=\basicStyle%
		, text align/.get=\textAlign%
		, skip above/.get=\skipAbove%
		, skip right/.get=\skipRight%
		, skip below/.get=\skipBelow%
		, skip left/.get=\skipLeft%
		, padding/.get=\padding%
	}%
	\begin{tcolorbox}[%
		boxrule=\borderWidth%
		, colframe=\borderColor%
		, enlarge top by=\skipAbove%
		, grow to right by=-\skipRight%
		, enlarge bottom by=\skipBelow%
		, grow to left by=-\skipLeft%
		% NOTE "top", ..., "left" are added to "boxsep" value for padding calculation
		, top=0pt%
		, right=0pt%
		, bottom=0pt%
		, left=0pt%
		, boxsep=\padding%
		, width=\width%
		, colback=\bg%
		, halign=\textAlign%
		, enlarge top by=\skipAbove%
		, enlarge bottom by=\skipBelow%
		, sharp corners=\sharpCorners%
	]%
		\ifnum\pdf@strcmp{\@empty}{\fg}=\z@\else%
		\expandafter\color\expandafter{\fg}\fi%
		\basicStyle{#2}%
	\end{tcolorbox}%
	\egroup%
}

%%
% Draw a table block.
%
% #1: (optional) Environment options.
%%
\newenvironment{classycv@PutTable}[1][]{%
	\bgroup%
	\pgfkeys{/classycv/data/put table/options/.cd, #1}%
	\pgfkeys{%
		/classycv/data/put table/options/.cd%
		, width/.get=\width%
		, basic style/.get=\basicStyle%
		, column format/.get=\columnFormat%
		, stretch/.get=\stretch%
		, skip above/.get=\skipAbove%
		, skip below/.get=\skipBelow%
	}%
	\ifdim\skipAbove=0pt\else\vspace*{\skipAbove}\par\fi%
	\basicStyle%
	\renewcommand{\arraystretch}{\stretch}%
	\expandafter\tabular\expandafter{\columnFormat}%
}{%
	\endtabular%
	\ifdim\skipBelow=0pt\par\else\vspace*{\skipBelow}\par\fi%
	\egroup%
}

%%
% Draw a list block.
%
% #1: (optional) Environment options.
%%
\newenvironment{classycv@PutList}[1][]{%
	\bgroup%
	\pgfkeys{/classycv/data/put list/options/.cd, #1}%
	\pgfkeys{%
		/classycv/data/put list/options/.cd%
		, basic style/.get=\basicStyle%
		, space between/.get=\spaceBetween
		, skip above/.get=\skipAbove%
		, skip below/.get=\skipBelow%
	}%
	\ifdim\skipAbove=0pt\else\vspace*{\skipAbove}\par\fi%
	\basicStyle%
	% Draw the itemize list.
	\begin{itemize}%
		\setlength{\itemsep}{\spaceBetween}%
		\setlength{\parskip}{0pt}%
		\setlength{\parsep}{0pt}%
}{%
	\end{itemize}%
	\ifdim\skipBelow=0pt\par\else\vspace*{\skipBelow}\par\fi%
	\egroup%
}

%%
% Put a resume entry with standard format.
%
% A standard format resume entry consists of three parts:
%	1. date line (first mandatory argument)
%	2. topic line (second mandatory argument)
%	3. free text (content of environment body)
%
% Parameter:
% #1: (optional) Environment options.
% #2: (mandatory) Date line text.
% #3: (mandatory) Topic line text.
%%
\newenvironment{classycv@PutResumeEntry}[3][]{%
	\bgroup%
	\pgfkeys{/classycv/data/put resume entry/options/.cd, #1}%
	\pgfkeys{%
		/classycv/data/put resume entry/options/.cd%
		, width/.get=\width%
		, basic style/.get=\basicStyle%
		, date line style/.get=\dateLineStyle%
		, topic line style/.get=\topicLineStyle%
		, skip above/.get=\skipAbove%
		, skip between/.get=\skipBetween%
		, skip below/.get=\skipBelow%
	}%
	\ifdim\skipAbove=0pt\else\vspace*{\skipAbove}\par\fi%
	\basicStyle%
	{\dateLineStyle{#2}\par}%
	{\topicLineStyle{#3}\par}%
	\vspace*{\skipBetween}%
}{%
	\ifdim\skipBelow=0pt\par\else\vspace*{\skipBelow}\par\fi%
	\egroup%
}

%%
% Draw a DIN 5008 type A conformant cover letter.
%
% DIN 5008 type A is german standard business letter format.
%
% #1, #2, #3, #4, #5, #6: see environment "CoverLetter".
%%
\newenvironment{classycv@PutCoverLetterDINLetterA}[6][]{%
	\bgroup%
	% Set data.
	\pgfkeys{/classycv/data/cover letter/DIN 5008 A/options/.cd, #1}
	\pgfkeys{/classycv/data/cover letter/DIN 5008 A/submitter/.cd, #2}
	\pgfkeys{/classycv/data/cover letter/DIN 5008 A/recipient/.cd, #3}
	\pgfkeys{%
		/classycv/data/cover letter/DIN 5008 A/.cd%
		, subject={#4}%
		, opening={#5}%
		, closing={#6}%
	}%
	% Define default components.
	\@ifundefined{/classycv/components/cover letter/header}{\classycvDefineComponent{/cover letter/header}{\classycv@PutCoverLetterDINLetterA@headerComponent}}{}%
	\@ifundefined{/classycv/components/cover letter/footer}{\classycvDefineComponent{/cover letter/footer}{\classycv@PutCoverLetterDINLetterA@footerComponent}}{}%
	\@ifundefined{/classycv/components/cover letter/recipient information}{\classycvDefineComponent{/cover letter/recipient information}{\classycv@PutCoverLetterDINLetterA@recipientInformationComponent}}{}%
	\@ifundefined{/classycv/components/cover letter/submitter information}{\classycvDefineComponent{/cover letter/submitter information}{\classycv@PutCoverLetterDINLetterA@submitterInformationComponent}}{}%
	\@ifundefined{/classycv/components/cover letter/subject}{\classycvDefineComponent{/cover letter/subject}{\classycv@PutCoverLetterDINLetterA@subjectComponent}}{}%
	\@ifundefined{/classycv/components/cover letter/date}{\classycvDefineComponent{/cover letter/date}{\classycv@PutCoverLetterDINLetterA@dateComponent}}{}%
	\@ifundefined{/classycv/components/cover letter/opening}{\classycvDefineComponent{/cover letter/opening}{\classycv@PutCoverLetterDINLetterA@openingComponent}}{}%
	\@ifundefined{/classycv/components/cover letter/closing}{\classycvDefineComponent{/cover letter/closing}{\classycv@PutCoverLetterDINLetterA@closingComponent}}{}%
	\@ifundefined{/classycv/components/cover letter/attachments}{\classycvDefineComponent{/cover letter/attachments}{\classycv@PutCoverLetterDINLetterA@attachmentsComponent}}{}%
	% Set page geometry and style.
	\loadgeometry{din-5008-a}%
	\pagestyle{cover-letter}%
	% Draw Recipient address and submitter information boxes.
	\pgfkeys{
		/classycv/data/cover letter/DIN 5008 A/options/.cd%
		, recipient information line color/.get=\recipientInformationLineColor%
		, recipient information padding/.get=\recipientInformationPadding%		
		, submitter information line color/.get=\submitterInformationLineColor%
		, submitter information padding/.get=\submitterInformationPadding%
	}%
	\begin{adjustbox}{margin=20mm 8.46mm 10mm 0mm, minipage=[t][45mm][t]{180mm}}%
		\begin{tikzpicture}
			\draw[use as bounding box, draw=none] (0, 0) rectangle (180mm, 55mm);%
			\node[below right=0pt and 0pt of current bounding box.north west, inner sep=\recipientInformationPadding, draw=\recipientInformationLineColor] {%
				\begin{adjustbox}{minipage=[t][45mm-\dimexpr2\dimexpr\recipientInformationPadding\relax][c]{85mm-\dimexpr2\dimexpr\recipientInformationPadding\relax}}%
					\classycv@PutComponent{/cover letter/recipient information}%
				\end{adjustbox}%		
			};%	
			\node[below left=5mm and 0pt of current bounding box.north east, inner sep=\submitterInformationPadding, draw=\submitterInformationLineColor] {%
				\begin{adjustbox}{minipage=[t][50mm-\dimexpr2\dimexpr\submitterInformationPadding\relax][c]{75mm-\dimexpr2\dimexpr\submitterInformationPadding\relax}}%
					\classycv@PutComponent{/cover letter/submitter information}%
				\end{adjustbox}%		
			};%
		\end{tikzpicture}%
	\end{adjustbox}\newline%
	% Optional letter body separator.
	\pgfkeys{/classycv/data/cover letter/DIN 5008 A/options/has body separator/.get=\hasBodySeparator}%
	\ifnum\pdf@strcmp{yes}{\hasBodySeparator}=\z@%
		\tikz{%
			\draw[draw=none, use as bounding box] rectangle (\linewidth, \baselineskip);
			\coordinate (P1) at ($([shift={(25mm, 0)}]current bounding box.north west)$);%
			\coordinate (P2) at ($([shift={(-20mm, 0)}]current bounding box.north east)$);%
			\draw[highlight-color] (P1) -- (P2);%
		}\par%
	\else%
		\vspace*{\classycv@baselineskip@default}\par
	\fi%
	% NOTE Width is A4 paper width (210mm) minus the left and right margins (25mm and 20mm) of the DIN 5008 A letter's text area
	% HREF http://tex.stackexchange.com/a/32707
	\begin{adjustwidth}{25mm}{20mm}%
		% DIN 5008 A defines unindented lines and one blank line as paragraph separator.
		\setlength{\parindent}{0pt}%
		\setlength{\parskip}{\classycv@baselineskip@default}%
		% Draw date component.
		\classycv@PutComponent{/cover letter/date}%
		% Draw subject component.
		\classycv@PutComponent{/cover letter/subject}%
		% Draw opening component.
		\classycv@PutComponent{/cover letter/opening}%
		% Draw content.
		\pgfkeys{/classycv/data/cover letter/DIN 5008 A/options/content style/.get=\contentStyle}
		\bgroup%
			\contentStyle%
}{%
		\egroup%
		% Draw closing component
		\classycv@PutComponent{/cover letter/closing}%
	\end{adjustwidth}%
	% TODO remove `\vspace` if not necessary.
	\vspace*{\fill}%
	\clearpage%
	\egroup%
}

% NOTE Default DIN 5008 A letter components

%%
% Default DIN 5008 A letter header component.
%%
\newcommand{\classycv@PutCoverLetterDINLetterA@headerComponent}{%
	\bgroup%
	\pgfkeys{/classycv/data/cover letter/DIN 5008 A/options/header repeat/.get=\repeat}%
	% Determine if the header should be drawn.
	\setboolean{classycv@@bI}{false}%
	\ifnum\pdf@strcmp{yes}{\repeat}=\z@%
		\setboolean{classycv@@bI}{true}%
	\else%
		\ifnum\theclassycv@coverLetterPageCounter=1%
		\setboolean{classycv@@bI}{true}%
		\fi%
	\fi%		
	\ifthenelse{\boolean{classycv@@bI}}{%
		\pgfkeys{%
			/classycv/data/cover letter/DIN 5008 A/options/.cd%
			, header basic style/.get=\basicStyle%
			, header foreground color/.get=\fg%
			, header name style/.get=\nameStyle%
			, header address style/.get=\addressStyle%
			, header details style/.get=\detailsStyle%
		}%
		\pgfkeys{%
			/classycv/data/cover letter/DIN 5008 A/submitter/.cd%
			, title/.get=\title%
			, name/.get=\name%
			, street/.get=\street%
			, house/.get=\house%
			, city/.get=\city%
			, zipcode/.get=\zipcode%
			, phone/.get=\phone%
			, mobile/.get=\mobile%
			, fax/.get=\fax%
			, email/.get=\email%
			, website/.get=\website%
		}%
		\begin{tikzpicture}%
			\draw[draw=none, use as bounding box] rectangle (210mm, 27mm);%
			% NOTE 25mm left shift aligns header with recipient information box.
			\coordinate (P1) at (25mm, 0);%
			% NOTE text width is reduced by 5mm from 170mm to align with right edge of text content box.
			\node[above right=0pt and 0pt of P1, inner sep=0pt, outer sep=0pt, text width=165mm] {%
				\expandafter\color\expandafter{\fg}\basicStyle%
				\setlength{\tabcolsep}{0pt}%
				\begin{tabular*}{\linewidth}{L{0.4\dimexpr\linewidth-2\tabcolsep\relax} L{0.6\dimexpr\linewidth-2\tabcolsep\relax}}%
					\adjustbox{minipage=[c][\dimexpr27mm-36pt\relax][c]{\linewidth}, margin=0pt}{%
						{\nameStyle\name}%
						\\\bgroup%
							\addressStyle%
							% Draw street and house number.
							\ifnum\pdf@strcmp{\street}{\@empty}=\z@\else\ifnum\pdf@strcmp{\house}{\@empty}=\z@\street\else\street~\house\fi\fi%
							% Draw zipcode and city.
							\ifnum\pdf@strcmp{\@empty}{\zipcode}=\z@\else%
								% Draw a bullet point as a delimiter if there is preceding text.
								\ifnum\pdf@strcmp{\@empty}{\street}=\z@\else~\textbullet~\fi%
								\ifnum\pdf@strcmp{\@empty}{\city}=\z@\city\else\zipcode~\city\fi%
							\fi%							
						\egroup%
					}%
				&%
					\adjustbox{minipage=[c][\dimexpr27mm-36pt\relax][c]{\linewidth}, margin=0pt}{%
						\detailsStyle%
						\setlength{\tabcolsep}{0pt}%
						\renewcommand{\arraystretch}{1.25}%
						\begin{tabular}[t]{L{0.5\dimexpr\linewidth-2\tabcolsep\relax} L{0.5\dimexpr\linewidth-2\tabcolsep\relax}}%
							\begin{tabular}[t]{C{2.5em} l}
								\ifnum\pdf@strcmp{\phone}{\@empty}=\z@\else{\large\Telefon}&\phone\\\fi%
								\ifnum\pdf@strcmp{\mobile}{\@empty}=\z@\else{\large\faMobile}&\mobile\fi%
							\end{tabular}% 
							& \begin{tabular}[t]{C{2.5em} l}%
								\ifnum\pdf@strcmp{\email}{\@empty}=\z@\else{\large\Letter}&\email\\\fi%
								\ifnum\pdf@strcmp{\website}{\@empty}=\z@\else{\large\ComputerMouse}&\website\fi%
							\end{tabular}%
						\end{tabular}%
					}%
				\end{tabular*}%
			};%
		\end{tikzpicture}%
	}{}%
	\egroup%
}

%%
% Default DIN 5008 A letter footer component.
%%
\newcommand{\classycv@PutCoverLetterDINLetterA@footerComponent}{%
	\bgroup%
	\pgfkeys{%
		/classycv/data/cover letter/DIN 5008 A/options/.cd%
		, has footer separator/.get=\hasFooterSeparator%
		, has page counter/.get=\hasPageCounter%
		, footer style/.get=\style%
		, footer foreground color/.get=\fg%
	}%
	\pgfkeys{/classycv/data/cover letter/DIN 5008 A/submitter/attachments/.get=\attachments}%
	% Draw component.
	\begin{tikzpicture}%
		\draw[draw=none, use as bounding box] rectangle (\textwidth, 42mm);
		% Draw optional footer separator.
		\ifnum\pdf@strcmp{yes}{\hasFooterSeparator}=\z@%
			\coordinate (P1) at ($([shift={(25mm, -4.23mm)}]current bounding box.north west)$);%
			\coordinate (P2) at ($([shift={(-20mm, -4.23mm)}]current bounding box.north east)$);%
			\draw[highlight-color] (P1) -- (P2);
		\fi%
		% Draw footer content node.
		\node[below right=\dimexpr4.23mm + \baselineskip\relax and 25mm of current bounding box.north west, text width=\dimexpr\textwidth - 45mm\relax, inner sep=0pt, outer sep=0pt] (footer) {%
			\expandafter\color\expandafter{\fg}\style\bgroup%
			\ifnum\pdf@strcmp{yes}{\hasPageCounter}=\z@%
				\begin{tabular}[t]{L{0.9\linewidth-2\tabcolsep} R{0.1\linewidth-2\tabcolsep}}%
					% Draw attachments.
						\ifnum\pdf@strcmp{\attachments}{\@empty}=\z@\else%
							\setcounter{classycv@@cI}{\the\numexpr\getpagerefnumber{cover-letter-\theclassycv@coverLetterCounter-last-page}-1}%
							\ifnum\thepage=\theclassycv@@cI%
								\faFilesO~~\attachments%
							\fi%
						\fi%
					& % Draw page counter.
						\theclassycv@coverLetterPageCounter~|~\the\numexpr\getpagerefnumber{cover-letter-\theclassycv@coverLetterCounter-last-page}-\getpagerefnumber{cover-letter-\theclassycv@coverLetterCounter-first-page}%
				\end{tabular}%
			\else%
				\ifnum\pdf@strcmp{\attachments}{\@empty}=\z@\else%
					\setcounter{classycv@@cI}{\the\numexpr\getpagerefnumber{cover-letter-\theclassycv@coverLetterCounter-last-page}-1}%
					\ifnum\thepage=\theclassycv@@cI%
						\stackbox[l]{\faFilesO~~\attachments}%
					\fi%
				\fi%
			\fi%
			\egroup%
		};%
	\end{tikzpicture}%
	\egroup%
}

%%
% Default DIN 5008 A letter recipient information components.
%%
\newcommand{\classycv@PutCoverLetterDINLetterA@recipientInformationComponent}{%
	\bgroup%
	\pgfkeys{%
		/classycv/data/cover letter/DIN 5008 A/options/.cd%
		, recipient information basic style/.get=\basicStyle%
		, recipient information organisation style/.get=\organisationStyle%
		, recipient information name style/.get=\nameStyle%
		, recipient information position style/.get=\positionStyle%
		, recipient information address style/.get=\addressStyle%
	}
	\pgfkeys{%
		/classycv/data/cover letter/DIN 5008 A/submitter/.cd%
		, name/.get=\submitterName%
		, street/.get=\submitterStreet%
		, house/.get=\submitterHouse%
		, zipcode/.get=\submitterZipcode
		, city/.get=\submitterCity
	}%
	\pgfkeys{%
		/classycv/data/cover letter/DIN 5008 A/recipient/.cd%
		, organisation/.get=\organisation%
		, position/.get=\position%
		, title/.get=\title%
		, name/.get=\name%
		, street/.get=\street%
		, house/.get=\house%
		, zipcode/.get=\zipcode%
		, city/.get=\city%
		, country/.get=\country%
	}%
	\basicStyle
	\vspace*{\classycv@baselineskip@default}%
	\ifnum\pdf@strcmp{\@empty}{\organisation}=\z@\else{\organisationStyle\organisation}\fi%
	\ifnum\pdf@strcmp{\@empty}{\name}=\z@\else\\{\nameStyle\title~\name}\fi%
	\ifnum\pdf@strcmp{\@empty}{\position}=\z@\else\\{\positionStyle\position}\fi%
	\ifnum\pdf@strcmp{\@empty}{\street}=\z@\else\\{\addressStyle\street~\house}\fi%
	\ifnum\pdf@strcmp{\@empty}{\zipcode}=\z@\else\\{\addressStyle\zipcode~\city}\fi%
	\ifnum\pdf@strcmp{\@empty}{\country}=\z@\else\\{\addressStyle\country}\fi%
	\egroup%
}

%%
% Default DIN 5008 A letter submitter information component.
% 
% NOTE Empty by default.
%%
\newcommand{\classycv@PutCoverLetterDINLetterA@submitterInformationComponent}{%
}

%%
% Default DIN 5008 A letter date component.
%%
\newcommand{\classycv@PutCoverLetterDINLetterA@dateComponent}{%
	\bgroup%
	\pgfkeys{/classycv/data/cover letter/DIN 5008 A/date/.get=\date}%
	\pgfkeys{/classycv/data/cover letter/DIN 5008 A/submitter/city/.get=\city}%
	% Skip the subject line if no subject was specified.
	\ifnum\pdf@strcmp{\@empty}{\date}=\z@%
	\else%
		\pgfkeys{/classycv/data/cover letter/DIN 5008 A/options/date line style/.get=\dateStyle}%
		% Reduce parskip such that the ragged left paragraph appears as a line.
		\setlength{\parskip}{0pt}%
		\ifnum\pdf@strcmp{\@empty}{\city}=\z@%
			{\raggedleft\dateStyle\date\par}%
		\else%
			{\raggedleft\dateStyle\city,~\date\par}%
		\fi
		% DIN 5008 A requires two empty lines after the date line.
		\vspace*{\baselineskip}\par%
		\setlength{\parskip}{\classycv@parskip@default}%
	\fi%
	\egroup%
}

%%
% Default DIN 5008 A letter subject component.
%%
\newcommand{\classycv@PutCoverLetterDINLetterA@subjectComponent}{%
	\bgroup%
	\pgfkeys{/classycv/data/cover letter/DIN 5008 A/subject/.get=\subject}%
	% Skip the subject line if no subject was specified.
	\ifnum\pdf@strcmp{\@empty}{\subject}=\z@%
	\else%
		\pgfkeys{/classycv/data/cover letter/DIN 5008 A/options/subject line style/.get=\subjectStyle}%
		{\subjectStyle\subject}%
		% DIN 5008 A requires two empty lines after the subject line.
		\vspace*{2\baselineskip}\par%
	\fi%
	\egroup%
}

%%
% Default DIN 5008 A letter opening component.
%%
\newcommand{\classycv@PutCoverLetterDINLetterA@openingComponent}{%
	\bgroup%
	\pgfkeys{/classycv/data/cover letter/DIN 5008 A/opening/.get=\opening}%
	% Skip the subject line if no subject was specified.
	\ifnum\pdf@strcmp{\@empty}{\opening}=\z@%
	\else%
		\pgfkeys{/classycv/data/cover letter/DIN 5008 A/options/opening line style/.get=\openingStyle}%
		% Reduce parskip to baseline skip.
		\setlength{\parskip}{0pt}
		% Append the opening line and add a line skip as per DIN 5008 A requirement.
		{\openingStyle\opening\par}%
	\fi%
	\egroup%
}

%%
% Default DIN 5008 A letter closing component.
%%
\newcommand{\classycv@PutCoverLetterDINLetterA@closingComponent}{%
	\bgroup%
	\pgfkeys{/classycv/data/cover letter/DIN 5008 A/closing/.get=\closing}%
	\pgfkeys{
		/classycv/data/cover letter/DIN 5008 A/submitter/.cd%
		, name/.get=\name%
		, organisation/.get=\organisation%
		, position/.get=\position%
	}%
	% Insert a blank line.
	\par%
	\stackbox[l]{%
		% Skip the closing line if no closing was specified.
		\ifnum\pdf@strcmp{\@empty}{\closing}=\z@%
		\else%
			\pgfkeys{/classycv/data/cover letter/DIN 5008 A/options/closing line style/.get=\closingStyle}%
			{\closingStyle\closing}%
		\fi%
		\pgfkeys{/classycv/data/cover letter/DIN 5008 A/options/signature basic style/.get=\signatureStyle}%
		\signatureStyle%
		% DIN 5008 A requires three empty lines before the rest of the closing block.
		\par\addvspace{3\baselineskip}%
		% Was a submitter name given?
		\ifnum\pdf@strcmp{\@empty}{\name}=\z@%
		\else%
			% Yes: append to closing block
			\pgfkeys{/classycv/data/cover letter/DIN 5008 A/options/signature name line style/.get=\nameStyle}%
			\par{\nameStyle\name}%
		\fi
		% Was a submitter position given?
		\ifnum\pdf@strcmp{\@empty}{\position}=\z@%
		\else
			% Yes: append to closing block.
			\pgfkeys{/classycv/data/cover letter/DIN 5008 A/options/signature position line style/.get=\positionLineStyle}
			\par{\positionLineStyle\position}%
		\fi%
		% Was a submitter organisation given?
		\ifnum\pdf@strcmp{\@empty}{\organisation}=\z@%
		\else%
			% Yes: append to closing block.
			\pgfkeys{/classycv/data/cover letter/DIN 5008 A/options/signature organisation line style/.get=\organisationLineStyle}%
			% DIN 5008 A requires one empty line before the organisation line in the closing block.
			\par{\organisationLineStyle\organisation}%
		\fi%
	}%
	\egroup%
}

%%
% Draw default DIN Letter 5008 A attachment component.
%%
\newcommand{\classycv@PutCoverLetterDINLetterA@attachmentsComponent}{%
	\bgroup%
	\pgfkeys{/classycv/data/cover letter/DIN 5008 A/submitter/attachments/.get=\attachments}
	% Were attachments given?
	\ifnum\pdf@strcmp{\attachments}{\@empty}=\z@\else%
		% Yes: put attachments line.
		\pgfkeys{/classycv/data/cover letter/DIN 5008 A/options/attachments style/.get=\attachmentsStyle}%
		\vfill%
		{\attachmentsStyle\faFilesO~~\attachments}%
	\fi%
	\egroup%
}

%%
% Draw a cover letter conforming to US business letter format in block format.
%
% #1, #2, #3, #4, #5, #6: see environment "CoverLetter".
%%
\newenvironment{classycv@PutCoverLetterUsBlock}[6][]{%
	\bgroup%
	% Set data.
	\pgfkeys{/classycv/data/cover letter/us block/options/.cd, #1}
	\pgfkeys{/classycv/data/cover letter/us block/submitter/.cd, #2}
	\pgfkeys{/classycv/data/cover letter/us block/recipient/.cd, #3}
	\pgfkeys{%
		/classycv/data/cover letter/us block/.cd%
		, subject={#4}%
		, opening={#5}%
		, closing={#6}%
	}%
	\pgfkeys{/classycv/data/cover letter/us block/options/content style/.get=\contentStyle}%
	% Define default components (non empty header component will raise warning).
	\@ifundefined{/classycv/components/cover letter/header}{\classycvDefineComponent{/cover letter/header}{}}{\ClassWarning{classycv}{(!) This letter format does not support a header component}}%
	\@ifundefined{/classycv/components/cover letter/footer}{\classycvDefineComponent{/cover letter/footer}{\classycv@PutCoverLetterUsBlock@footerComponent}}{}%
	\@ifundefined{/classycv/components/cover letter/submitter information}{\classycvDefineComponent{/cover letter/submitter information}{\classycv@PutCoverLetterUsBlock@submitterInformationComponent}}{}%
	\@ifundefined{/classycv/components/cover letter/date}{\classycvDefineComponent{/cover letter/date}{\classycv@PutCoverLetterUsBlock@dateComponent}}{}%
	\@ifundefined{/classycv/components/cover letter/recipient information}{\classycvDefineComponent{/cover letter/recipient information}{\classycv@PutCoverLetterUsBlockA@recipientInformationComponent}}{}%
	\@ifundefined{/classycv/components/cover letter/opening}{\classycvDefineComponent{/cover letter/opening}{\classycv@PutCoverLetterUsBlock@openingComponent}}{}%
	\@ifundefined{/classycv/components/cover letter/subject}{\classycvDefineComponent{/cover letter/subject}{\classycv@PutCoverLetterUsBlock@subjectComponent}}{}%
	\@ifundefined{/classycv/components/cover letter/closing}{\classycvDefineComponent{/cover letter/closing}{\classycv@PutCoverLetterUsBlock@closingComponent}}{}%
	% Set page geometry and style.
	\loadgeometry{us-business-cover-letter}%
	\pagestyle{cover-letter}%
	% Set paragraph indentation to zero
	\setlength{\parindent}{0pt}%
	% Draw components.
	\begin{adjustwidth}{0pt}{0pt}%
		\classycv@PutComponent{/cover letter/submitter information}%
		\classycv@PutComponent{/cover letter/date}%
		\classycv@PutComponent{/cover letter/recipient information}%
		\classycv@PutComponent{/cover letter/opening}%
		\classycv@PutComponent{/cover letter/subject}%
		% Insert a blank line.
		\vspace*{\baselineskip}\par
		\bgroup%
			\contentStyle%
}{%
		\egroup%
		\classycv@PutComponent{/cover letter/closing}%
	\end{adjustwidth}%
	\clearpage%
	\egroup%
}

%%
% Default US cover letter block format footer component.
%%
\newcommand{\classycv@PutCoverLetterUsBlock@footerComponent}{%
	\bgroup%
	\pgfkeys{%
		/classycv/data/cover letter/us block/options/.cd%
		, has footer separator/.get=\hasFooterSeparator%
		, has page counter/.get=\hasPageCounter%
		, footer style/.get=\style
	}%
	\pgfkeys{/classycv/data/cover letter/us block/submitter/attachments/.get=\attachments}%
	% Draw component.
	\begin{tikzpicture}
		\draw[draw=none, use as bounding box, inner sep=0pt, outer sep=0pt] rectangle (\textwidth, \classycv@GEOMETRY@USBLOCK@FOOTERHEIGHT);
		% Draw footer content node.
		\node[below right=0pt and 0pt of current bounding box.north west, inner sep=0pt, outer sep=0pt, text width=\textwidth, text height=0.66\classycv@GEOMETRY@USBLOCK@FOOTERHEIGHT, text depth=0.34\classycv@GEOMETRY@USBLOCK@FOOTERHEIGHT] (footer) {%
			\style%
			% Was a list of attachments provided?
			\ifnum\pdf@strcmp{\attachments}{\@empty}=\z@%
			\else%
				% Yes: draw attachments if this is the last page.
				\setcounter{classycv@@cI}{\the\numexpr\getpagerefnumber{cover-letter-\theclassycv@coverLetterCounter-last-page}-1}%
				\ifnum\thepage=\theclassycv@@cI%
					\faFilesO~~\attachments%
				\fi%
			\fi%
			% Draw page counter if enabled.
			\ifnum\pdf@strcmp{no}{\hasPageCounter}=\z@%
			\else%
				\hfill\theclassycv@coverLetterPageCounter~|~\the\numexpr\getpagerefnumber{cover-letter-\theclassycv@coverLetterCounter-last-page}-\getpagerefnumber{cover-letter-\theclassycv@coverLetterCounter-first-page}%
			\fi%
		};%
	\end{tikzpicture}
	\egroup%
}

%%
% Default sender information component for a US business letter in block format.
%%
\newcommand{\classycv@PutCoverLetterUsBlock@submitterInformationComponent}{%
	\bgroup%
	\pgfkeys{%
		/classycv/data/cover letter/us block/options/.cd%
		, submitter information basic style/.get=\basicStyle%
		, submitter information address style/.get=\addressStyle%
		, submitter information organisation style/.get=\organisationStyle%
		, submitter information phone style/.get=\phoneStyle%
		, submitter information email style/.get=\emailStyle%
	}%
	\pgfkeys{%
		/classycv/data/cover letter/us block/submitter/.cd%
		, title/.get=\title%
		, organisation/.get=\organisation%
%		, position/.get=\position%
		, street/.get=\street%
		, house/.get=\house%
		, zipcode/.get=\zipcode%	
		, city/.get=\city%
		, country/.get=\country%
		, phone/.get=\phone%
		, email/.get=\email%
	}%
	\basicStyle%
	\ifnum\pdf@strcmp{\@empty}{\organisation}=\z@\else{\organisationStyle\organisation}\\\fi%
	% address
	{\addressStyle%
		\ifnum\pdf@strcmp{\@empty}{\street}=\z@\else%
			\ifnum\pdf@strcmp{\@empty}{\house}=\z@\else\house~\fi%
			\street\\\fi%
		\ifnum\pdf@strcmp{\@empty}{\city}=\z@\else%
			\ifnum\pdf@strcmp{\@empty}{\zipcode}=\z@\else\zipcode,~\fi%
			\city\\\fi%
		\ifnum\pdf@strcmp{\@empty}{\country}=\z@\else\country\\\fi%
	}%
	\ifnum\pdf@strcmp{\@empty}{\phone}=\z@\else{\phoneStyle\phone}\\\fi%
	\ifnum\pdf@strcmp{\@empty}{\email}=\z@\else{\emailStyle\email}\fi%
	\egroup%
}

%%
% Default DIN 5008 A letter date component.
%%
\newcommand{\classycv@PutCoverLetterUsBlock@dateComponent}{%
	\bgroup%
	\pgfkeys{%
		/classycv/data/cover letter/us block/options/.cd%
		, date line style/.get=\dateStyle%
	}%
	\pgfkeys{%
		/classycv/data/cover letter/us block/submitter/.cd%
		, date/.get=\date%
	}%
	% Insert a blank line.
	\vspace*{\baselineskip}\par
	\dateStyle%
	% Draw the date line and a blank line.
	\ifnum\pdf@strcmp{\@empty}{\date}=\z@\else%
		{\date}\fi%
	\egroup%
}

%%
% Default recipient information component for a US business letter in block format.
%%
\newcommand{\classycv@PutCoverLetterUsBlockA@recipientInformationComponent}{%
	\bgroup%
	\pgfkeys{%
		/classycv/data/cover letter/us block/options/.cd%
		, recipient information basic style/.get=\basicStyle%
		, recipient information organisation style/.get=\organisationStyle%
		, recipient information name style/.get=\nameStyle%
		, recipient information address style/.get=\addressStyle%
	}%
	\pgfkeys{%
		/classycv/data/cover letter/us block/recipient/.cd%
		, title/.get=\title%
		, name/.get=\name%
		, organisation/.get=\organisation%
		, street/.get=\street%
		, house/.get=\house%
		, zipcode/.get=\zipcode%	
		, city/.get=\city%
		, country/.get=\country%
	}%
	% Insert a blank line.
	\vspace*{\baselineskip}\par
	\basicStyle%
	{\nameStyle%
		\ifnum\pdf@strcmp{\@empty}{\name}=\z@\else%
			\ifnum\pdf@strcmp{\@empty}{\title}=\z@\else\title~\fi%
			\name\\\fi%
	}%
	\ifnum\pdf@strcmp{\@empty}{\organisation}=\z@\else\organisation\\\fi%
	{\addressStyle%
		\ifnum\pdf@strcmp{\@empty}{\street}=\z@\else%
			\ifnum\pdf@strcmp{\@empty}{\house}=\z@\else\house~\fi%
			\street\\\fi%
		\ifnum\pdf@strcmp{\@empty}{\city}=\z@\else%
			\ifnum\pdf@strcmp{\@empty}{\zipcode}=\z@\else\zipcode,~\fi%
			\city\\\fi%
		\ifnum\pdf@strcmp{\@empty}{\country}=\z@\else\country\\\fi%
	}%
	\egroup%
}

%%
% Default opening component for US cover letter in block format.
%%
\newcommand{\classycv@PutCoverLetterUsBlock@openingComponent}{%
	\bgroup%
	\pgfkeys{/classycv/data/cover letter/us block/opening/.get=\opening}%
	\pgfkeys{/classycv/data/cover letter/us block/options/opening line style/.get=\openingStyle}%
	% Skip the subject line if no subject was specified.
	\ifnum\pdf@strcmp{\@empty}{\opening}=\z@%
	\else%
		% Insert a blank line.
		\vspace*{\baselineskip}\par
		% Append the opening line and add a line skip as per DIN 5008 A requirement.
		{\openingStyle\opening}%
	\fi%
	\egroup%
}

%%
% Default subject component for US cover letter in block format.
%%
\newcommand{\classycv@PutCoverLetterUsBlock@subjectComponent}{%
	\bgroup%
	\pgfkeys{/classycv/data/cover letter/us block/subject/.get=\subject}%
	\pgfkeys{/classycv/data/cover letter/us block/options/subject line style/.get=\subjectStyle}%
	% Skip the subject line if no subject was specified.
	\ifnum\pdf@strcmp{\@empty}{\subject}=\z@%
	\else%
		% Insert a blank line.
		\vspace*{\baselineskip}\par
		\begin{center}%
		{\subjectStyle\subject}%
		\end{center}%
	\fi%
	\egroup%
}

%%
% Default closing component for US cover letter in block format.
%%
\newcommand{\classycv@PutCoverLetterUsBlock@closingComponent}{%
	\bgroup%
	\pgfkeys{/classycv/data/cover letter/us block/closing/.get=\closing}%
	\pgfkeys{
		/classycv/data/cover letter/us block/submitter/.cd%
		, name/.get=\name%
		, organisation/.get=\organisation%
		, position/.get=\position%
	}%
	\pgfkeys{/classycv/data/cover letter/us block/options/.cd%
		, closing line style/.get=\closingStyle%
		, signature basic style/.get=\basicStyle%
		, signature name line style/.get=\nameStyle%
		, signature position line style/.get=\nameStyle%
	}%
	\basicStyle%
	% Insert a blank line and draw closing line.
	\vspace*{\baselineskip}\par%
	\ifnum\pdf@strcmp{\@empty}{\closing}=\z@
		\else{\closingStyle\closing}\fi
	% Insert two blank lines and draw submitter name and position.
	\vspace*{2\baselineskip}\par%
	\ifnum\pdf@strcmp{\@empty}{\name}=\z@%
		\else{\nameStyle\name}\\\fi%
	\ifnum\pdf@strcmp{\@empty}{\position}=\z@%
		\else{\nameStyle\position}\\\fi%
	\egroup%
}

%%
% Classic cover letter format.
%
% #1, #2: see environment "Resume".
%%
\newenvironment{classycv@PutResumeClassic}[2][]{%
	\bgroup%
	\pgfkeys{/classycv/data/settings/resume/classic/options/.cd, #1}%
	\pgfkeys{/classycv/data/settings/resume/classic/.cd, #2}%
	\@ifundefined{/classycv/components/resume/header}{\classycvDefineComponent{/resume/header}{\classycv@PutResumeClassic@headerComponent}}{}%
	\@ifundefined{/classycv/components/resume/footer}{\classycvDefineComponent{/resume/footer}{\classycv@PutResumeClassic@footerComponent}}{}%
	% Set page geometry and style; clear page.
	\loadgeometry{resume-classic}%
	\pagestyle{resume-classic}%
	\clearpage%
	% Set indentation to zero.
	\setlength{\parindent}{0pt}%
}{%
	\vfill%
	% Restore indentation.
	\setlength{\parindent}{\classycv@parindent@default}%
	\clearpage%
	\egroup%
}

%%
% Default classic resume header.
%%
\newcommand{\classycv@PutResumeClassic@headerComponent}{%
	\bgroup%
	\pgfkeys{/classycv/data/settings/resume/classic/.cd%
		, name/.get=\name%
		, title/.get=\title%
	}%
	\pgfkeys{/classycv/data/settings/resume/classic/options/.cd%
		, header basic style/.get=\basicStyle%
		, header foreground color/.get=\fg%
		, has header delimiter/.get=\hasDelimiter%
		, header delimiter color/.get=\delimiterColor%
	}%
	\tikz {%
		\draw[draw=none, use as bounding box] rectangle (0, \classycv@GEOMETRY@RESUMECLASSIC@HEADERHEIGHT);
		\node[draw=none, inner sep=0pt, outer sep=0pt, below right=0pt and 0pt of current bounding box.north west, text width=\textwidth, text height=\dimexpr0.66\classycv@GEOMETRY@RESUMECLASSIC@HEADERHEIGHT\relax, text depth=\dimexpr0.34\classycv@GEOMETRY@RESUMECLASSIC@HEADERHEIGHT\relax] {%
			\expandafter\color\expandafter{\fg}\basicStyle%
				{\name\hfill\title}%
		};%
		\ifnum\pdf@strcmp{\@empty}{\hasDelimiter}=\z@\else\draw[draw=\delimiterColor] (0, 0) -- (\textwidth, 0);\fi%
	}%
	\egroup%
}

%%
% Default classic resume footer.
%%
\newcommand{\classycv@PutResumeClassic@footerComponent}{%
	\bgroup%
	\pgfkeys{/classycv/data/settings/resume/classic/.cd%
		, phone/.get=\phone%
		, email/.get=\email%
	}%
	\pgfkeys{/classycv/data/settings/resume/classic/options/.cd%
		, footer basic style/.get=\basicStyle%
		, footer foreground color/.get=\fg%
		, has footer delimiter/.get=\hasDelimiter%
		, footer delimiter color/.get=\delimiterColor%
	}%
	\tikz {%
		\draw[draw=none, use as bounding box] rectangle (0, \classycv@GEOMETRY@RESUMECLASSIC@FOOTERHEIGHT);
		\ifnum\pdf@strcmp{\@empty}{\hasDelimiter}=\z@\else\draw[draw=\delimiterColor] (0, \classycv@GEOMETRY@RESUMECLASSIC@FOOTERHEIGHT) -- (\textwidth, \classycv@GEOMETRY@RESUMECLASSIC@FOOTERHEIGHT);\fi%
		\node[draw=none, inner sep=0pt, outer sep=0pt, below right=0pt and 0pt of current bounding box.north west, text width=\textwidth, text height=\dimexpr0.66\classycv@GEOMETRY@RESUMECLASSIC@FOOTERHEIGHT\relax, text depth=\dimexpr0.34\classycv@GEOMETRY@RESUMECLASSIC@FOOTERHEIGHT\relax] {%
			\expandafter\color\expandafter{\fg}\basicStyle%
				{\phone\hfill\email}%
		};%
	}%
	\egroup%
}

%%
% Modern resume format.
%
% #1, #2: see environment "Resume".
%%
\newenvironment{classycv@PutResumeModern}[2][]{%
	\bgroup%
	% Gather options and parameters.
	\pgfkeys{/classycv/data/resume/modern/options/.cd, #1}%
	\pgfkeys{/classycv/data/resume/modern/.cd, #2}%
	\pgfkeys{%
		/classycv/data/resume/modern/options/.cd%
		, right basic style/.get=\rightStyle%
		, right foreground color/.get=\rightFg%
		, left background color/.get=\leftBg%
		, delimiter color/.get=\delimiterColor%
		, delimiter width/.get=\delimiterWidth%
	}%
	% Define default components
	\@ifundefined{/classycv/components/resume/header}{\classycvDefineComponent{/resume/header}{}}{\ClassWarning{classycv}{(!) This resume format does not support a header component}}%
	\@ifundefined{/classycv/components/resume/footer}{\classycvDefineComponent{/resume/footer}{}}{\ClassWarning{classycv}{(!) This resume format does not support a footer component}}%
	\@ifundefined{/classycv/components/resume/left}{\classycvDefineComponent{/resume/left}{\classycv@PutResumeModern@leftComponent}}{}%
	\@ifundefined{/classycv/components/resume/left/picture}{\classycvDefineComponent{/resume/left/picture}{\classycv@PutResumeModern@left@pictureComponent}}{}%
	\@ifundefined{/classycv/components/resume/left/title}{\classycvDefineComponent{/resume/left/title}{\classycv@PutResumeModern@left@titleComponent}}{}%
	\@ifundefined{/classycv/components/resume/left/personal data}{\classycvDefineComponent{/resume/left/personal data}{\classycv@PutResumeModern@left@personalDataComponent}}{}%
	\@ifundefined{/classycv/components/resume/left/contact data}{\classycvDefineComponent{/resume/left/contact data}{\classycv@PutResumeModern@left@contactDataComponent}}{}%
	\@ifundefined{/classycv/components/resume/left/extra data}{\classycvDefineComponent{/resume/left/extra data}{\classycv@PutResumeModern@left@extraDataComponent}}{}%
	% Set left component width.
	\setlength{\classycv@@lI}{\dimexpr0.7\textwidth}%
	\setlength{\classycv@@lII}{\dimexpr0.3\textwidth}%
	\setlength{\classycv@@lIII}{\dimexpr\paperheight-2\classycv@GEOMETRY@BLANK@MARGIN}%
	% Set page geometry and style; clear page.
	\loadgeometry{blank}%
	\pagestyle{blank}%
	\clearpage%
	% Set indentation to zero.
	\setlength{\parindent}{0pt}%
	% Draw left and right content boxes using tcolorbox.
	\begin{tcolorbox}[%
		blanker%
		% Shift the right box part to the right by the width of the left side plus left page margin.
		, leftupper=\dimexpr\classycv@@lII+\dimexpr\classycv@GEOMETRY@BLANK@MARGIN\relax%
		% Add slight padding.
%		, boxsep=2em%
        , width=\textwidth%
        , height fixed for=all%
        , height fill=true%
        , breakable%
        , break at=\textheight%
        % Draw left page side as overlay.
		, overlay unbroken and first={%	
			\draw[fill=\leftBg, draw=none, use as bounding box] rectangle (\classycv@@lII, \classycv@@lIII);%
			\node[draw=none, text width=\classycv@@lII, below right=0pt and 0pt of current bounding box.north west, outer sep=0pt, inner sep=0pt]{%
				\classycv@PutComponent{/resume/left}%
			};%
			% Draw delimiting vertical line.
			\draw[draw=\delimiterColor, line width=\delimiterWidth, opacity=0.25] (\dimexpr\classycv@@lII+\classycv@GEOMETRY@BLANK@MARGIN, \classycv@GEOMETRY@BLANK@MARGIN) -- (\dimexpr\classycv@@lII+\classycv@GEOMETRY@BLANK@MARGIN, \classycv@@lIII);%
		}%
		, overlay middle and last={%
			\draw[fill=\leftBg, draw=none, use as bounding box] rectangle (\classycv@@lII, \classycv@@lIII);%
			\node[draw=none, text width=\classycv@@lII, below right=0pt and 0pt of current bounding box.north west, outer sep=0pt, inner sep=0pt]{%
				\classycv@PutComponent{/resume/left}%
			};%
			% Draw delimiting vertical line.
			\draw[draw=\delimiterColor, line width=\delimiterWidth, opacity=0.25] (\dimexpr\classycv@@lII+\classycv@GEOMETRY@BLANK@MARGIN, \classycv@GEOMETRY@BLANK@MARGIN) -- (\dimexpr\classycv@@lII+\classycv@GEOMETRY@BLANK@MARGIN, \classycv@@lIII);%
		}%
	]%
	\bgroup\expandafter\color\expandafter{\rightFg}\rightStyle%
	\begin{center}%
		\begin{varwidth}{\dimexpr\classycv@@lI-1in\relax}%
}{%
		\end{varwidth}%
	\end{center}%
	\egroup%
	\vfill%
	\end{tcolorbox}%
	% Restore indentation.
	\setlength{\parindent}{\classycv@parindent@default}%
	\clearpage%
	\egroup%
}

%%
% Modern resume format default left component. 
%%
\newcommand{\classycv@PutResumeModern@leftComponent}{%
	\bgroup%
	\pgfkeys{%
		/classycv/data/resume/modern/options/.cd%
		, left foreground color/.get=\rightFg%
		, left basic style/.get=\style%
	}%
	\style\expandafter\color\expandafter{\rightFg}%
	% Picture.
	\classycv@PutComponent{/resume/left/picture}%
	% Draw title.
	\classycv@PutComponent{/resume/left/title}%
	% Draw personal data.
	\classycv@PutComponent{/resume/left/personal data}%
	% Draw contact data.
	\classycv@PutComponent{/resume/left/contact data}%
	% Draw extra data (optional).
	\classycv@PutComponent{/resume/left/extra data}%
	\egroup%
}

%%
% Modern resume format default picture component. 
%%
\newcommand{\classycv@PutResumeModern@left@pictureComponent}{%
	\bgroup%
	\pgfkeys{/classycv/data/resume/modern/picture/.get=\picture}%
	\ifnum\pdf@strcmp{\@empty}{\picture}=\z@%
		\vspace*{2\baselineskip}\par%
	\else%
		\includegraphics[width=\linewidth]{\picture}%
		\\[2\baselineskip]%
	\fi%
	\egroup%
}

%%
% Modern resume format default left title component.
%%
\newcommand{\classycv@PutResumeModern@left@titleComponent}{%
	\bgroup%
	\pgfkeys{%
		/classycv/data/resume/modern/.cd%
		, name/.get=\name%
		, title/.get=\title%
	}%
	\pgfkeys{%
		/classycv/data/resume/modern/options/.cd%
		, left title style/.get=\titleStyle%
		, left title name style/.get=\titleNameStyle%
	}%
	\begin{center}%
		\ifnum\pdf@strcmp{\@empty}{\name}=\z@\else%
			{\titleStyle{\name}}\\\fi%
		\ifnum\pdf@strcmp{\@empty}{\title}=\z@\else%
			{\titleNameStyle{\title}}\\\fi%
	\end{center}%
	\egroup%
}

%%
% Modern resume format default personal data component for left side.
%%
\newcommand{\classycv@PutResumeModern@left@personalDataComponent}{%
	\bgroup%
	\pgfkeys{/classycv/data/resume/modern/personal data heading text/.get=\text}%
	% Put picture.
	\pgfkeys{%
		/classycv/data/resume/modern/.cd%
		, birthdate/.get=\birthdate%
		, marital status/.get=\status%
		, nationality/.get=\nationality%
	}%
	% NOTE Parameters handed down need to be expanded first.
	\edef\@@headerColor{\pgfkeysvalueof{/classycv/data/resume/modern/options/left header color}}%
	\edef\@@backgroundColor{\pgfkeysvalueof{/classycv/data/resume/modern/options/left background color}}%
	% Put personal data.
	\heading[%
		, width=\dimexpr\linewidth-12pt\relax%
		, skip above=2\baselineskip%
		, skip below=0pt%
		, skip left=12pt%
		, basic style=\pgfkeysvalueof{/classycv/data/resume/modern/options/left header style}%
		, foreground color=\@@headerColor%
		, background color=\@@backgroundColor%
		, border width=0pt%
		, border color=accent-color%
		, padding=0pt%
	] {\circle[border width=2pt]\faUser~~\text}%
	\hspace*{6pt}%
	\begin{varwidth}{\linewidth-12pt}%
		\begin{Table}[%
			, skip below=\baselineskip%
			, column format={C{0.175\linewidth} p{0.825\linewidth-3\tabcolsep}}%
			, basic style=\pgfkeysvalueof{/classycv/data/resume/modern/options/left entry style}%
		]%
			\ifnum\pdf@strcmp{\birthdate}{\@empty}=\z@%
			\else%
				{\larger[2]\cmbrfamily\textborn}&\birthdate\\%
			\fi%
			\ifnum\pdf@strcmp{\status}{\@empty}=\z@%
			\else%
				{\larger[2]\cmbrfamily\textmarried}&\status\\%
			\fi%
			\ifnum\pdf@strcmp{\nationality}{\@empty}=\z@%
			\else%
				{\larger[2]\cmbrfamily\Mundus}&\nationality%
			\fi%
		\end{Table}%
	\end{varwidth}%
	\\%
	\egroup%
}

%%
% Modern resume format default contact data component for left side.
%%
\newcommand{\classycv@PutResumeModern@left@contactDataComponent}{%
	\bgroup%
	\pgfkeys{/classycv/data/resume/modern/contact data heading text/.get=\text}%
	\pgfkeys{%
		/classycv/data/resume/modern/.cd%
		, phone/.get=\phone%
		, mobile/.get=\mobile%
		, email/.get=\email%
		, website/.get=\website%
	}%
	\pgfkeys{%
		/classycv/data/resume/modern/options/.cd%
		, left foreground color/.get=\fg%
		, left entry style/.get=\entryStyle%
	}%
	% NOTE Parameters handed down need to be expanded first.
	\edef\@@headerColor{\pgfkeysvalueof{/classycv/data/resume/modern/options/left header color}}%
	\edef\@@backgroundColor{\pgfkeysvalueof{/classycv/data/resume/modern/options/left background color}}%
	% Put contact data.
	\heading[%
		width=\dimexpr\linewidth-12pt\relax%
		, skip above=2\baselineskip%
		, skip below=0pt%
		, skip left=12pt%
		, basic style=\pgfkeysvalueof{/classycv/data/resume/modern/options/left header style}%
		, foreground color=\@@headerColor%
		, background color=\@@backgroundColor%
		, border width=0pt%
		, border color=accent-color%
		, padding=0pt%
	] {\circle[border width=2pt]\faComments~~\text}%
	\hspace*{6pt}%
	\begin{varwidth}{\linewidth-12pt}%
		\begin{Table}[%
%			skip above=\baselineskip%
			, skip below=\baselineskip%
			, column format={C{0.175\linewidth} p{0.825\linewidth-3\tabcolsep}}%
			, basic style=\entryStyle%
		]%	
			\ifnum\pdf@strcmp{\phone}{\@empty}=\z@\else{\larger[2]\cmbrfamily\Telefon}&\phone\\\fi%
			\ifnum\pdf@strcmp{\mobile}{\@empty}=\z@\else{\larger[2]\cmbrfamily\faMobile}&\mobile\\\fi%
			\ifnum\pdf@strcmp{\email}{\@empty}=\z@\else{\larger[2]\cmbrfamily\Letter}&\email\\\fi%
			\ifnum\pdf@strcmp{\website}{\@empty}=\z@\else{\larger[2]\cmbrfamily\ComputerMouse}&\website\fi%
		\end{Table}%
	\end{varwidth}%
	\\%
	\egroup%
}

%%
% Modern resume format default extra dat component for left side.
%%
\newcommand{\classycv@PutResumeModern@left@extraDataComponent}{}%

%%
% Default attachment header.
%
% NOTE Empty by default.
%%
\newcommand{\classycv@attachment@headerComponent}{%
}

%%
% Default attachment footer component.
%%
\newcommand{\classycv@attachment@footerComponent}{%
	\bgroup%
	\pgfkeys{%
		/classycv/data/attachment/.cd%
		, name/.get=\attachmentName%
	}%
	\pgfkeys{%
		/classycv/data/attachment/options/.cd%
		, has page counter/.get=\hasPageCounter%
		, background color/.get=\bg%
		, foreground color/.get=\fg%
		, basic style/.get=\basicStyle%
	}%
	% TODO parameterize?
	\def\@@lineWidth{2pt}%
	\setlength{\classycv@@lI}{\dimexpr\classycv@GEOMETRY@ATTACHMENT@FOOTERHEIGHT\relax}%
	% Calculate depth.
	\tikz{%
		\draw[use as bounding box, draw=none, fill=\bg] rectangle (\paperwidth, \classycv@GEOMETRY@ATTACHMENT@FOOTERHEIGHT);%
		\draw[draw=none, fill=highlight-color] (0, \dimexpr\classycv@@lI-\@@lineWidth\relax) rectangle (\textwidth, \classycv@@lI);%
		\node[draw=none, minimum width=\paperwidth, text width=\paperwidth, text height=\dimexpr0.50\classycv@@lI\relax, text depth=\dimexpr0.50\classycv@@lI\relax, inner sep=0pt, outer sep=0pt, below right=\dimexpr\@@lineWidth\relax and 0pt of current bounding box.north west]{%
			\hspace*{\baselineskip}%
			\ifnum\pdf@strcmp{\@empty}{\attachmentName}=\z@\else%
				\expandafter\color\expandafter{\fg}\basicStyle{\bfseries\faFilesO}~\attachmentName%
			\fi%
			\hfill%
			\ifnum\pdf@strcmp{yes}{\hasPageCounter}=\z@%
				\setcounter{classycv@@cI}{\getpagerefnumber{attachment-\theclassycv@attachmentCounter-first-page}}%
				\setcounter{classycv@@cII}{\getpagerefnumber{attachment-\theclassycv@attachmentCounter-last-page}}%
				\expandafter\color\expandafter{\fg}\basicStyle{\number\numexpr1 + \thepage - \theclassycv@@cI\relax~|~\number\numexpr\theclassycv@@cII-\theclassycv@@cI\relax}%
			\fi%
			\hspace*{\baselineskip}%
		};%
	}%
	\egroup%
}

\makeatother
	
% % % % % % 
% settings %
% % % % % %

% NOTE tabularx settings

% NOTE Centered fixed width column.
% HREF http://tex.stackexchange.com/a/238023
\newcolumntype{C}[1]{>{\centering\arraybackslash}p{#1}}
\newcolumntype{L}[1]{>{\raggedright\arraybackslash}p{#1}}
\newcolumntype{R}[1]{>{\raggedleft\arraybackslash}p{#1}}
\newcolumntype{M}[1]{>{\centering\arraybackslash}m{#1}}

\makeatletter

% NOTE pgfkeys interface and default value declaration.

\pgfkeys{%
	/classycv/data/settings/cover letter/.cd%
	, format/.initial=\classycv@FORMAT@COVERLETTER@DINLETTERA%
	, format/.default=\classycv@FORMAT@COVERLETTER@DINLETTERA%
}

\pgfkeys{%
	/classycv/data/draw circle/options/.cd%
	, height/.initial=\dimexpr1.5\baselineskip\relax%
	, height/.default=\dimexpr1.5\baselineskip\relax%
	, border width/.initial=1pt%
	, border width/.default=1pt%
	, border color/.default=%
	, border color/.initial=%
	, padding/.initial=\dimexpr0.25\ht\strutbox\relax%
	, padding/.default=\dimexpr0.25\ht\strutbox\relax%
	, background color/.initial=%
	, background color/.default=%
	, text color/.initial=%
	, text color/.default=%
}

\pgfkeys{%
	/classycv/data/put bar/options/.cd%
	, width/.initial=\dimexpr\linewidth-24pt\relax%
	, width/.default=\dimexpr\linewidth-24pt\relax%
	, height/.initial=1em%
	, height/.default=1em%
	, color/.initial=highlight-color%
	, color/.default=highlight-color%
	, strength/.initial=2pt%
	, strength/.default=2pt%
	, skip above/.initial=1em%
	, skip above/.default=1em%	
	, skip below/.initial=2em%
	, skip below/.default=2em%	
}

\pgfkeys{%
	/classycv/data/put progress bar/options/.cd%
	, height/.initial=\baselineskip%
	, height/.default=\baselineskip%
	, background color/.initial=accent-color!25!nearly-white%
	, background color/.default=accent-color!25!nearly-white%
	, foreground color/.initial=accent-color%
	, foreground color/.default=accent-color%	
	, width/.initial=\linewidth%
	, width/.default=\linewidth%
	, border width/.initial=0pt
	, border width/.default=0pt	
	, border color/.initial=none%
	, border color/.default=none%
	, has label/.initial=no%
	, has label/.default=no%
	, label width/.initial=0pt%
	, label width/.default=0pt%
	, label position/.initial=left%
	, label position/.default=left%
	, label text/.initial=\@empty%
	, label text/.default=\@empty%
	, label font/.initial=\normalsize%
	, label font/.default=\normalsize%
	, label text align/.initial=left%
	, label text align/.default=left%
	, label color/.initial=accent-color%
	, label color/.default=accent-color%
	, skip above/.initial=1em%
	, skip above/.default=1em%	
	, skip below/.initial=2em%
	, skip below/.default=2em%	
	, skip between/.initial=4pt%
	, skip between/.default=4pt%
}

\pgfkeys{%
	/classycv/data/put semicircle/options/.cd%
	, size/.initial=2em%
	, size/.default=2em%
	, strength/.initial=2pt%
	, strength/.default=2pt%
	, line color/.initial=accent-color%
	, line color/.default=accent-color%
	, fill color/.initial=white!0%
	, fill color/.default=white!0%
	, has label/.initial=no%
	, has label/.default=no%
	, label text/.initial=\@empty%
	, label text/.default=\@empty%
	, label font/.initial=\normalsize%
	, label font/.default=\normalsize%
	, label color/.initial=accent-color%
	, label color/.default=accent-color%
	, draw complement/.initial=yes%
	, draw complement/.default=yes%
	, complement line color/.initial=light-gray%
	, complement line color/.default=light-gray%
	, draw glow/.initial=no%
	, draw glow/.default=no%
}

\pgfkeys{%
	/classycv/data/put doughnut chart/options/.cd%
	, size/.initial=2em%
	, size/.default=2em%
	, strength/.initial=2pt%
	, strength/.default=2pt%
%	, line color/.initial=accent-color%
%	, line color/.default=accent-color%
	, label size/.initial=1em%
	, label size/.default=1em%
	, label shape/.initial=circle%
	, label shape/.default=circle%
	, label line color/.initial=white%
	, label line color/.default=white%
	, label fill color/.initial=white%
	, label fill color/.default=white%
	, label text color/.default=dark-gray%
	, label text color/.initial=dark-gray%
	, basic style/.initial={\robotofamily\tiny\fontseries{l}\selectfont}%
	, basic style/.default={\robotofamily\tiny\fontseries{l}\selectfont}%
}

\pgfkeys{%
	/classycv/data/put heading/options/.cd%
	, width/.initial=\linewidth%
	, width/.default=\linewidth%
	, height/.initial=2em%
	, height/.default=2em%
	, border color/.initial=white%
	, border color/.default=white%
	, border width/.initial=0pt%
	, border width/.default=0pt%
	, sharp corners/.initial=all%
	, sharp corners/.default=all%
	, basic style/.initial={\flafamily\larger[2]\bfseries}%
	, basic style/.default={\flafamily\larger[2]\bfseries}%
	, background color/.initial=white%
	, background color/.default=white%
	, foreground color/.initial=accent-color%
	, foreground color/.default=accent-color%
	, text align/.initial=left%
	, text align/.default=left%
	, skip above/.initial=\baselineskip%
	, skip above/.default=\baselineskip%
	, skip right/.initial=0pt%
	, skip right/.default=0pt%
	, skip below/.initial=2\baselineskip%
	, skip below/.default=2\baselineskip%
	, skip left/.initial=0pt%
	, skip left/.default=0pt%
	, padding/.initial=0.5em%
	, padding/.default=0.5em%
}

\pgfkeys{%
	/classycv/data/put table/options/.cd%
	, width/.initial=\dimexpr\linewidth-24pt\relax%
	, width/.default=\dimexpr\linewidth-24pt\relax%
	, basic style/.initial={\robotofamily\normalsize\fontseries{l}\selectfont}%
	, basic style/.default={\robotofamily\normalsize\fontseries{l}\selectfont}%
	, column format/.initial={R{0.2\dimexpr\linewidth-48pt} L{0.8\dimexpr\linewidth-48pt}}%
	, column format/.default={l l}%
	, stretch/.initial={1.0}%
	, stretch/.default={1.0}%
	, skip above/.initial=1em%
	, skip above/.default=1em%
	, skip below/.initial=2em%
	, skip below/.default=2em%	
}

\pgfkeys{%
	/classycv/data/put list/options/.cd%
	, basic style/.initial={\robotofamily\fontseries{l}\selectfont}%
	, basic style/.default={\robotofamily\fontseries{l}\selectfont}%
	, space between/.initial=0pt%
	, space between/.default=0pt%
	, skip above/.initial=1em%
	, skip above/.default=1em%
	, skip below/.initial=0pt%
	, skip below/.default=0pt%
}

\pgfkeys{%
	/classycv/data/put resume entry/options/.cd%
	, width/.initial=\dimexpr\linewidth-24pt\relax%
	, width/.default=\dimexpr\linewidth-24pt\relax%
	, basic style/.initial={\robotofamily\fontseries{l}\selectfont}%
	, basic style/.default={\robotofamily\fontseries{l}\selectfont}%
	, date line style/.initial={\flafamily\normalsize\bfseries}
	, date line style/.default={\flafamily\normalsize\bfseries}
	, topic line style/.initial={\flafamily\normalsize\fontseries{l}\selectfont}
	, topic line style/.default={\flafamily\normalsize\fontseries{l}\selectfont}
	, skip above/.initial=0pt%
	, skip above/.default=0pt%
	, skip between/.initial=0.5\baselineskip%
	, skip between/.default=0.5\baselineskip%
	, skip below/.initial=\baselineskip%
	, skip below/.default=\baselineskip%	
}

\pgfkeys{%
	/classycv/data/cover letter/DIN 5008 A/options/.cd%
	, has body separator/.initial=yes%
	, has body separator/.default=yes%
	, has footer separator/.initial=yes%
	, has footer separator/.default=yes%
	, has page counter/.initial=yes%
	, has page counter/.default=yes%
	, header repeat/.initial=no%
	, header repeat/.default=no%
	, header basic style/.initial={\flafamily}%
	, header basic style/.default={\flafamily}%
	, header foreground color/.initial=accent-color%
	, header foreground color/.default=accent-color%
	, header name style/.initial={\Large\mdseries}%
	, header name style/.default={\Large\mdseries}%
	, header address style/.initial={\footnotesize\fontseries{l}\selectfont}%
	, header address style/.default={\footnotesize\fontseries{l}\selectfont}%
	, header details style/.initial={\footnotesize\fontseries{l}\selectfont}%
	, header details style/.default={\footnotesize\fontseries{l}\selectfont}%
	, recipient information line color/.initial=medium-gray%
	, recipient information line color/.default=medium-gray%
	, recipient information padding/.initial=1em%
	, recipient information padding/.default=1em%
	, recipient information basic style/.initial={\fontsize{3.75mm}{3.75mm}\selectfont}%
	, recipient information basic style/.default={\fontsize{3.75mm}{3.75mm}\selectfont}%
	, recipient information organisation style/.initial={\robotofamily\MakeUppercase}%
	, recipient information organisation style/.default={\robotofamily\MakeUppercase}%
	, recipient information name style/.initial={\robotofamily\fontseries{b}\selectfont}%
	, recipient information name style/.default={\robotofamily\fontseries{b}\selectfont}%
	, recipient information position style/.initial={\itshape}%
	, recipient information position style/.default={\itshape}%
	, recipient information address style/.initial={\robotofamily\fontseries{m}}%
	, recipient information address style/.default={\robotofamily\fontseries{m}}%
	, submitter information line color/.initial=medium-gray%
	, submitter information line color/.default=medium-gray%
	, submitter information padding/.initial=1em%
	, submitter information padding/.default=1em%
	, submitter information basic style/.initial={\fontsize{3.75mm}{3.75mm}\selectfont}%
	, submitter information basic style/.default={\fontsize{3.75mm}{3.75mm}\selectfont}%
	, date line style/.initial={\robotofamily\normalsize}%
	, date line style/.default={\robotofamily\normalsize}%
	, subject line style/.initial={\robotofamily\normalsize\bfseries}%
	, subject line style/.default={\robotofamily\normalsize\bfseries}%
	, opening line style/.initial={\lmrfamily\normalsize}%
	, opening line style/.default={\lmrfamily\normalsize}%
	, content style/.initial={\lmrfamily\normalsize}%
	, content style/.default={\lmrfamily\normalsize}%
	, closing line style/.initial={\lmrfamily\normalsize}%
	, closing line style/.default={\lmrfamily\normalsize}%
	, signature basic style/.initial={\lmrfamily\normalsize}%
	, signature basic style/.default={\lmrfamily\normalsize}%	
	, signature name line style/.initial=%
	, signature name line style/.default=%
	, signature position line style/.initial=%
	, signature position line style/.default=%
	, signature organisation line style/.initial={\MakeUppercase}%
	, signature organisation line style/.default={\MakeUppercase}%
	, footer style/.initial={\robotofamily\small\fontseries{l}\selectfont\MakeUppercase}%
	, footer style/.default={\robotofamily\small\fontseries{l}\selectfont\MakeUppercase}%
	, footer foreground color/.initial=medium-gray%
	, footer foreground color/.default=medium-gray%
}

\pgfkeys{%
	/classycv/data/cover letter/DIN 5008 A/submitter/.cd%
	, title/.initial=?title%
	, title/.default=?title%
	, name/.initial=?name%
	, name/.default=?name%
	, organisation/.initial=?organisation%
	, organisation/.default=?organisation%
	, position/.initial=?position%
	, position/.default=?position%
	, street/.initial=?street%
	, street/.default=?street%
	, house/.initial=?house%
	, house/.default=?house%
	, zipcode/.initial=?zipcode%	
	, zipcode/.default=?zipcode%	
	, city/.initial=?city%
	, city/.default=?city%	
	, country/.initial=?country%
	, country/.default=?country%
	, phone/.initial=?phone%
	, phone/.default=?phone%	
	, mobile/.initial=?mobile%
	, mobile/.default=?mobile%
	, fax/.initial=?fax%
	, fax/.default=?fax%
	, email/.initial=?email%
	, email/.default=?email%	
	, website/.initial=?website%
	, website/.default=?website%
	, sign/.initial=?sign%
	, sign/.default=?sign%
	, reply sign/.initial=?reply%
	, reply sign/.default=?reply%
	, original sign/.initial=?original%
	, original sign/.default=?original%	
	, date/.initial=?date%
	, date/.default=?date%	
	, reply message date/.initial=?reply%
	, reply message date/.default=?reply%	
	, original message date/.initial=?original message%
	, original message date/.default=?original message%
	, attachments/.initial=?attachments%
	, attachments/.default=?attachments%	
}

\pgfkeys{%
	/classycv/data/cover letter/DIN 5008 A/recipient/.cd%
	, rta/.initial=?rta%
	, rta/.default=?rta%
	, title/.initial=?title%
	, title/.default=?title%
	, name/.initial=?name%
	, name/.default=?name%
	, organisation/.initial=?organisation%
	, organisation/.default=?organisation%
	, position/.initial=?position%
	, position/.default=?position%
	, street/.initial=?street%
	, street/.default=?street%
	, house/.initial=?house%
	, house/.default=?house%
	, zipcode/.initial=?zipcode%
	, zipcode/.default=?zipcode%
	, city/.initial=?city%
	, city/.default=?city%
	, country/.initial=?country%
	, country/.default=?country%
}	

\pgfkeys{%
	/classycv/data/cover letter/DIN 5008 A/.cd%
	, date/.initial=\today%
	, date/.default=\today%
	, subject/.initial=?subject%
	, subject/.default=?subject%
	, opening/.initial=?opening%
	, opening/.default=?opening%
	, closing/.initial=?closing%
	, closing/.default=?closing%
}%

% TODO remove unneeded interface key-val declarations.
\pgfkeys{%
	/classycv/data/cover letter/us block/options/.cd%
	, has body separator/.initial=yes%
	, has body separator/.default=yes%
	, has footer separator/.initial=yes%
	, has footer separator/.default=yes%
	, has page counter/.initial=yes%
	, has page counter/.default=yes%
	, recipient information basic style/.initial={\robotofamily\fontseries{l}\selectfont\normalsize}%
	, recipient information basic style/.default={\robotofamily\fontseries{l}\selectfont\normalsize}%
	, recipient information organisation style/.initial=%{\robotofamily\MakeUppercase}%
	, recipient information organisation style/.default=%{\robotofamily\MakeUppercase}%
	, recipient information name style/.initial={\robotofamily\bfseries\normalsize}%
	, recipient information name style/.default={\robotofamily\bfseries\normalsize}%
	, recipient information address style/.initial=%{\robotofamily\fontseries{m}\selectfont}%
	, recipient information address style/.default=%{\robotofamily\fontseries{m}\selectfont}%
	, submitter information basic style/.initial={\robotofamily\fontseries{l}\selectfont\normalsize}%
	, submitter information basic style/.default={\robotofamily\fontseries{l}\selectfont\normalsize}%
	, submitter information address style/.initial=%{\robotofamily\fontseries{m}\selectfont}%
	, submitter information address style/.default=%{\robotofamily\fontseries{m}\selectfont}%
	, submitter information organisation style/.initial=%{\robotofamily\MakeUppercase}%
	, submitter information organisation style/.default=%{\robotofamily\MakeUppercase}%
	, submitter information phone style/.initial=%{\robotofamily\fontseries{m}\selectfont}%
	, submitter information phone style/.default=%{\robotofamily\fontseries{m}\selectfont}%
	, submitter information email style/.initial=%{\robotofamily\fontseries{m}\selectfont}%
	, submitter information email style/.default=%{\robotofamily\fontseries{m}\selectfont}%
	, date line style/.initial={\robotofamily\fontseries{l}\selectfont\normalsize}%
	, date line style/.default={\robotofamily\fontseries{l}\selectfont\normalsize}%
	, subject line style/.initial={\robotofamily\normalsize\bfseries\MakeUppercase}%
	, subject line style/.default={\robotofamily\normalsize\bfseries\MakeUppercase}%
	, opening line style/.initial={\lmrfamily\normalsize}%
	, opening line style/.default={\lmrfamily\normalsize}%
	, content style/.initial={\lmrfamily\normalsize}%
	, content style/.default={\lmrfamily\normalsize}%
	, closing line style/.initial={\lmrfamily\normalsize}%
	, closing line style/.default={\lmrfamily\normalsize}%
	, signature basic style/.initial={\lmrfamily\normalsize}%
	, signature basic style/.default={\lmrfamily\normalsize}%	
	, signature name line style/.initial=%
	, signature name line style/.default=%
	, signature position line style/.initial=%
	, signature position line style/.default=%
	, signature organisation line style/.initial={\MakeUppercase}%
	, signature organisation line style/.default={\MakeUppercase}%
%	, attachments style/.initial={\robotofamily\fontseries{l}\selectfont\normalsize\color{medium-gray}}%
%	, attachments style/.default={\robotofamily\fontseries{l}\selectfont\normalsize\color{medium-gray}}%
	, footer style/.initial={\robotofamily\small\mdseries}
	, footer style/.default={\robotofamily\small\mdseries}
}

\pgfkeys{%
	/classycv/data/cover letter/us block/submitter/.cd%
	, title/.initial=?title%
	, title/.default=?title%
	, name/.initial=?name%
	, name/.default=?name%
	, organisation/.initial=?organisation%
	, organisation/.default=?organisation%
	, position/.initial=?position%
	, position/.default=?position%
	, street/.initial=?street%
	, street/.default=?street%
	, house/.initial=?house%
	, house/.default=?house%
	, zipcode/.initial=?zipcode%	
	, zipcode/.default=?zipcode%	
	, city/.initial=?city%
	, city/.default=?city%	
	, country/.initial=?country%
	, country/.default=?country%
	, phone/.initial=?phone%
	, phone/.default=?phone%	
	, mobile/.initial=?mobile%
	, mobile/.default=?mobile%
	, fax/.initial=?fax%
	, fax/.default=?fax%
	, email/.initial=?email%
	, email/.default=?email%	
	, website/.initial=?website%
	, website/.default=?website%
	, date/.initial=?date%
	, date/.default=?date%	
	, attachments/.initial=?attachments%
	, attachments/.default=?attachments%	
}

\pgfkeys{%
	/classycv/data/cover letter/us block/recipient/.cd%
	, title/.initial=?title%
	, title/.default=?title%
	, name/.initial=?name%
	, name/.default=?name%
	, organisation/.initial=?organisation%
	, organisation/.default=?organisation%
	, position/.initial=?position%
	, position/.default=?position%
	, street/.initial=?street%
	, street/.default=?street%
	, house/.initial=?house%
	, house/.default=?house%
	, zipcode/.initial=?zipcode%
	, zipcode/.default=?zipcode%
	, city/.initial=?city%
	, city/.default=?city%
	, country/.initial=?country%
	, country/.default=?country%
}	

\pgfkeys{%
	/classycv/data/cover letter/us block/.cd%
	, date/.initial=?date%
	, date/.default=?date%
	, subject/.initial=?subject%
	, subject/.default=?subject%
	, opening/.initial=?opening%
	, opening/.default=?opening%
	, closing/.initial=?closing%
	, closing/.default=?closing%
}%

\pgfkeys{%
	/classycv/data/settings/resume/.cd%
	, format/.initial=\classycv@FORMAT@RESUME@CLASSIC%
	, format/.default=\classycv@FORMAT@RESUME@CLASSIC%	
}

% NOTE Classic resume settings and options
\pgfkeys{%
	/classycv/data/settings/resume/classic/.cd%
	, name/.initial=?name%
	, name/.default=?name%
	, title/.initial=?title%
	, title/.default=?title%
	, phone/.initial=?phone%
	, phone/.default=?phone%
	, email/.initial=?email%
	, email/.default=?email%
}%

\pgfkeys{%
	/classycv/data/settings/resume/classic/options/.cd%
	, header basic style/.initial={\robotofamily\fontseries{l}\selectfont\normalsize\MakeUppercase}%
	, header basic style/.default={\robotofamily\fontseries{l}\selectfont\normalsize\MakeUppercase}%
	, has header delimiter/.default=yes%
	, has header delimiter/.initial=yes%
	, header delimiter color/.initial=light-gray%
	, header delimiter color/.default=light-gray%
	, header foreground color/.initial=medium-gray%
	, header foreground color/.default=medium-gray%
	, footer basic style/.initial={\robotofamily\fontseries{l}\selectfont\small\MakeUppercase}%
	, footer basic style/.default={\robotofamily\fontseries{l}\selectfont\small\MakeUppercase}%
	, footer foreground color/.initial=medium-gray%
	, footer foreground color/.default=medium-gray%
	, has footer delimiter/.default=yes%
	, has footer delimiter/.initial=yes%
	, footer delimiter color/.initial=light-gray%
	, footer delimiter color/.default=light-gray%
}%

% NOTE Modern resume settings and options
\pgfkeys{%
	/classycv/data/resume/modern/.cd%
	, picture/.initial=\@empty%
	, picture/.default=\@empty%
	, name/.initial=?name%
	, name/.default=?name%
	, title/.initial=?title%
	, title/.default=?title%
	, street/.initial=?street%
	, street/.default=?street%
	, house/.initial=?house%
	, house/.default=?house%
	, zipcode/.initial=?zipcode%
	, zipcode/.default=?zipcode%
	, city/.initial=?city%
	, city/.default=?city%
	, country/.initial=?initial%
	, country/.default=?initial%
	, birthdate/.initial=?birthdate%
	, birthdate/.default=?birthdate%
	, marital status/.initial=?marital status%
	, marital status/.default=?marital status%
	, nationality/.initial=?nationality%
	, nationality/.default=?nationality%
	, phone/.initial=?phone%
	, phone/.default=?phone%
	, mobile/.initial=?mobile%
	, mobile/.default=?mobile%
	, email/.initial=?email%
	, email/.default=?email%
	, website/.initial=?website%
	, website/.default=?website%
	, personal data heading text/.initial=?personal data heading text%
	, personal data heading text/.default=?personal data heading text%
	, contact data heading text/.initial=?contact data heading text%
	, contact data heading text/.default=?contact data heading text%
%!	, submitter information basic style/.initial=\@empty%
%!	, submitter information basic style/.default=\@empty%
}

\pgfkeys{%
	/classycv/data/resume/modern/options/.cd%
	, left basic style/.initial={\robotofamily\fontseries{l}\selectfont\small}%
	, left basic style/.default={\robotofamily\fontseries{l}\selectfont\small}%
	, left foreground color/.initial=highlight-color%
	, left foreground color/.default=highlight-color%
	, left background color/.initial=white%
	, left background color/.default=white%
	, left address style/.initial={\flafamily\fontseries{l}\selectfont\larger}%
	, left address style/.default={\flafamily\fontseries{l}\selectfont\larger}%
	, left header style/.initial={\flafamily\bfseries\larger[2]}%
	, left header style/.default={\flafamily\bfseries\larger[2]}%
	, left header color/.initial=accent-color%
	, left header color/.default=accent-color%
	, left header label color/.initial=accent-color%
	, left header label color/.default=accent-color%
	, left header skip before/.initial={\bigskip}%
	, left header skip before/.default={\bigskip}%
	, left entry style/.initial={\robotofamily\fontseries{l}\selectfont\small}%
	, left entry style/.default={\robotofamily\fontseries{l}\selectfont\small}%
	, left entry skip above/.initial={}%
	, left entry skip above/.default={}%
	, left entry skip below/.initial={\smallskip}%
	, left entry skip below/.default={\smallskip}%
	, right basic style/.initial={\robotofamily\fontseries{l}\selectfont\normalsize}%
	, right basic style/.default={\robotofamily\fontseries{l}\selectfont\normalsize}%	
	, left title style/.initial={\larger[3]\bfseries}
	, left title style/.default={\larger[3]\bfseries}
	, left title name style/.initial={\larger[2]\fontseries{l}\selectfont}
	, left title name style/.default={\larger[2]\fontseries{l}\selectfont}
	, right foreground color/.initial=black%
	, right foreground color/.default=black%
	, delimiter color/.initial=highlight-color%
	, delimiter color/.default=highlight-color%
	, delimiter width/.initial=2pt%
	, delimiter width/.default=2pt%
}

%
% Attachment data
%
\pgfkeys{%
	/classycv/data/attachment/.cd%
	, name/.initial=\@empty%
	, name/.default=\@empty%
}

\pgfkeys{%
	/classycv/data/attachment/options/.cd%
	, has page counter/.initial=yes%
	, background color/.initial=accent-color%
	, background color/.default=accent-color%
	, foreground color/.initial=white%
	, foreground color/.default=white%
	, basic style/.initial={\robotofamily\fontseries{l}\selectfont\footnotesize}%
	, basic style/.default={\robotofamily\fontseries{l}\selectfont\footnotesize}%
}

% NOTE Page geometry definitions.

\geometry{}
\savegeometry{default}

%%
% Blank page geomtery with added margins for printing.
%%
\newlength{\classycv@GEOMETRY@BLANK@MARGIN}
%!\setlength{\classycv@GEOMETRY@BLANK@MARGIN}{5mm}
\setlength{\classycv@GEOMETRY@BLANK@MARGIN}{0pt}
\newgeometry{%
	% Ignore header, footer, margin par
	noheadfoot%
	, nomarginpar%
	, ignoreall%
	, width=\paperwidth%
	, height=\paperheight%
%	, headheight=0pt%
	, tmargin=\classycv@GEOMETRY@BLANK@MARGIN%
	, rmargin=\classycv@GEOMETRY@BLANK@MARGIN%
	, bmargin=\classycv@GEOMETRY@BLANK@MARGIN%
	, lmargin=\classycv@GEOMETRY@BLANK@MARGIN%
}
\savegeometry{blank}

%%
% DIN 5008 A letter page format
% 
% HREF http://tex.stackexchange.com/a/111380 (setting footer height)
% HREF https://de.wikipedia.org/wiki/DIN_5008#/media/File:DIN_5008,_Form_A.svg
%%
\newgeometry{%
	includeheadfoot%
	, nomarginpar%
	, headheight=27mm%
	, headsep=6pt%
	, foot=4.38mm%
	, footskip=0mm
	, tmargin=0mm%
	% guesstimation from drawing on Wikipedia
	, bmargin=42mm
	, width=\the\paperwidth%
	, height=\the\paperheight%
}
\savegeometry{din-5008-a}

%%
% US business cover letter page geometry.
%
% HREF https://en.wikipedia.org/wiki/Business_letter
% HREF https://www.linkedin.com/pulse/british-american-business-letters-differences-types-academy-bea-
%%
\newlength{\classycv@GEOMETRY@USBLOCK@MARGIN}
\setlength{\classycv@GEOMETRY@USBLOCK@MARGIN}{1in}
\newlength{\classycv@GEOMETRY@USBLOCK@FOOTERHEIGHT}
\setlength{\classycv@GEOMETRY@USBLOCK@FOOTERHEIGHT}{2\baselineskip}
\newgeometry{%
	% Ignore header
	nohead
	, includefoot%
	, nomarginpar%
	, foot=0pt%
	, footskip=\dimexpr0.5\classycv@GEOMETRY@USBLOCK@MARGIN\relax%
	, tmargin=\classycv@GEOMETRY@USBLOCK@MARGIN%
	, rmargin=\classycv@GEOMETRY@USBLOCK@MARGIN%
	% Add up bottom margin and footer height to properly space content and footer.
	, bmargin=\dimexpr\classycv@GEOMETRY@USBLOCK@MARGIN + \dimexpr\classycv@GEOMETRY@USBLOCK@FOOTERHEIGHT\relax%
	, lmargin=\classycv@GEOMETRY@USBLOCK@MARGIN%
	, width=\dimexpr\paperwidth-\dimexpr2\classycv@GEOMETRY@USBLOCK@MARGIN%
	, height=\dimexpr\paperheight-\dimexpr2\classycv@GEOMETRY@USBLOCK@MARGIN%
}
\savegeometry{us-business-cover-letter}

%%
% Classic resume page format
% HREF https://resumegenius.com/how-to-write-a-resume/resume-fonts-margins-paper-guidelines (for margins)
%%
\newlength{\classycv@GEOMETRY@RESUMECLASSIC@HEADFOOTSKIP}
\setlength{\classycv@GEOMETRY@RESUMECLASSIC@HEADFOOTSKIP}{0.1in}
\newlength{\classycv@GEOMETRY@RESUMECLASSIC@LEFTRIGHTMARGIN}
\setlength{\classycv@GEOMETRY@RESUMECLASSIC@LEFTRIGHTMARGIN}{0.63in}
\newlength{\classycv@GEOMETRY@RESUMECLASSIC@TOPBOTTOMMARGIN}
\setlength{\classycv@GEOMETRY@RESUMECLASSIC@TOPBOTTOMMARGIN}{1in}
\newlength{\classycv@GEOMETRY@RESUMECLASSIC@HEADERHEIGHT}
\setlength{\classycv@GEOMETRY@RESUMECLASSIC@HEADERHEIGHT}{1.5\baselineskip}
\newlength{\classycv@GEOMETRY@RESUMECLASSIC@FOOTERHEIGHT}
\setlength{\classycv@GEOMETRY@RESUMECLASSIC@FOOTERHEIGHT}{1.5\baselineskip}

\newgeometry{%
	includeheadfoot%
	, nomarginpar%
	, headheight=\classycv@GEOMETRY@RESUMECLASSIC@HEADERHEIGHT%
	, headsep=\classycv@GEOMETRY@RESUMECLASSIC@HEADFOOTSKIP%
	% Add up footer skip and footer height to properly space bottom of footer from bottom of content box.
	, footskip=\dimexpr\classycv@GEOMETRY@RESUMECLASSIC@HEADFOOTSKIP + \classycv@GEOMETRY@RESUMECLASSIC@FOOTERHEIGHT\relax%
	, tmargin=\classycv@GEOMETRY@RESUMECLASSIC@TOPBOTTOMMARGIN%
	, rmargin=\classycv@GEOMETRY@RESUMECLASSIC@LEFTRIGHTMARGIN%
	, bmargin=\classycv@GEOMETRY@RESUMECLASSIC@TOPBOTTOMMARGIN%
	, lmargin=\classycv@GEOMETRY@RESUMECLASSIC@LEFTRIGHTMARGIN%
}
\savegeometry{resume-classic}

\newpagestyle{resume-classic}{%
	\setheadrule{0pt}%
	\setfootrule{0pt}%
	\sethead{%
		% Increase the cover letter page counter.
		%\stepcounter{classycv@coverLetterPageCounter}%	
		\classycv@PutComponent{/resume/header}%
	}{}{}%
	\setfoot{%
		\classycv@PutComponent{/resume/footer}%
	}{}{}%
}

%%
% Attachment geometry.
%%
\newlength{\classycv@GEOMETRY@ATTACHMENT@FOOTERHEIGHT}
\setlength{\classycv@GEOMETRY@ATTACHMENT@FOOTERHEIGHT}{15mm}
\newlength{\classycv@GEOMETRY@ATTACHMENT@FOOTSKIP}
\setlength{\classycv@GEOMETRY@ATTACHMENT@FOOTSKIP}{5mm}
\newgeometry{%
	includefoot%
	, nomarginpar%
	, headheight=0pt%
	, headsep=0pt%
	, foot=0pt%
	, footskip=\dimexpr\classycv@GEOMETRY@ATTACHMENT@FOOTERHEIGHT+\classycv@GEOMETRY@ATTACHMENT@FOOTSKIP\relax%
	, tmargin=0pt%
	, rmargin=0pt%
	, bmargin=0pt%
	, lmargin=0pt%
	, width=\the\paperwidth%
	, height=\the\paperheight%
}
\savegeometry{attachment}

\newpagestyle{blank}{%
	\setheadrule{0pt}%
	\setfootrule{0pt}%
	\sethead{}{}{}%
	\setfoot{}{}{}%
}

\newpagestyle{cover-letter}{%
	% Remove header rule and footer rule.
	\setheadrule{0pt}%
	\setfootrule{0pt}%
	\sethead{%
		% Increase the cover letter page counter.
		\stepcounter{classycv@coverLetterPageCounter}%	
		\classycv@PutComponent{/cover letter/header}%
	}{}{}%
	\setfoot{%
		\classycv@PutComponent{/cover letter/footer}%
	}{}{}%
}

\newpagestyle{attachment}{%
	% Remove header rule and footer rule.
	\setheadrule{0pt}%
	\setfootrule{0pt}%
	\sethead{}{}{}%
	\setfoot{%
		\classycv@PutComponent{/attachment/footer}%
	}{}{}%
}

\usetikzlibrary{positioning, calc, shapes, svg.path, shadows}
\pgfdeclarelayer{background}
\pgfdeclarelayer{overlay 1}
\pgfdeclarelayer{overlay 2}
\pgfsetlayers{background,main,overlay 1,overlay 2}

\tcbuselibrary{breakable}
\tcbuselibrary{skins}

% NOTE Obnoxious and totally unwarranted self advertisement (:
\AtEndDocument{%
	\clearpage%
	\newpage%
	\loadgeometry{blank}%
	\pagestyle{empty}%
	\vspace*{\fill}%
		\begin{center}
			\Huge\flafamily\fontseries{l}\selectfont Made with package \textcolor{accent-color}{\bfseries classycv} for \LaTeX2e
		\end{center}%
	\vspace*{\fill}%
}
