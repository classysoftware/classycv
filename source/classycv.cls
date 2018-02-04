% INFO A LaTeX2e class for writing classy job applications. 
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
	% NOTE This parameter has to be declared in order for `\loadgeometry` to actually change the layout.
	%! showframe%
	, pass%
	, margin=0pt%
]{geometry}
\RequirePackage{titleps}
\RequirePackage{tikz}
\RequirePackage{pdftexcmds}
\RequirePackage{environ}
% NOTE for maximum width nodes
% HREF http://tex.stackexchange.com/a/46479
\RequirePackage{varwidth}
% NOTE Minipage like environment with customizable left and right margins
%!ref http://tex.stackexchange.com/a/32707
\RequirePackage{changepage}
% NOTE For `\getpagerefnumber` (extract number values from page labels).
\RequirePackage{refcount}
% NOTE For `\adjustbox` and `\marginbox`
%!ref http://tex.stackexchange.com/a/28638
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

\makeatletter

% NOTE Font selection.
\newcommand{\cmrfamily}{\fontfamily{cmr}\selectfont}
\newcommand{\lmrfamily}{\fontfamily{lmr}\selectfont}
\newcommand{\cmbrfamily}{\fontfamily{cmbr}\selectfont}
\renewcommand{\robotofamily}{\fontfamily{Roboto-LF}\selectfont}
\newcommand{\berafamily}{\fontfamily{fve}\selectfont}

% NOTE Intersperse all characters within the second given string with the first given string.
\newcommand{\classycv@intersperse}[2]{%
	%! This should not be reached.
	\ifnum\pdf@strcmp{#2}{\@empty}=\z@%
	\else%
		%! Split at the first character.
		\StrSplit{#2}{1}{\classycv@a}{\classycv@b}%
		%! Last character?
		\ifnum\pdf@strcmp{\classycv@b}{\@empty}=\z@%
			%! Yes: put last character.
			\classycv@a%
		\else%
			%! No: intersperse and continue.
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
\newcommand{\classycv@wrapWithCircle}[2][]{%
	% Were optional arguments given?
	\ifnum\pdf@strcmp{#1}{\@empty}=\z@%
		% No: don't pass to node.
		\tikz[baseline=(char.base)]{\node[inner sep=1pt, draw, circle, thick] (char) {#2};}
	\else%
		% Yes: pass to node.
		\tikz[baseline=(char.base)]{\node[inner sep=1pt, draw, circle, draw, thick, #1] (char) {#2};}
	\fi%
}

% TODO remove?
\iffalse
\newcommand*\circled[1]{%
	\tikz[baseline=(char.base)]{\node[shape=circle,draw,inner sep=2pt] (char) {#1};}%
}
\fi

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
\newcommand{\classycv@FORMAT@RESUME@THIRTYSEVENTY}{thirty-seventy}

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
	\else%
		% Invalid letter format.
		\ClassWarning{classycv}{(!) undefined letter format (\classycv@format)}%
	\fi%
}{%
	% Close cover letter environment.
	\pgfkeys{/classycv/data/settings/cover letter/format/.get=\classycv@format}%
	\ifnum\pdf@strcmp{\classycv@format}{\classycv@FORMAT@COVERLETTER@DINLETTERA}=\z@%
		\end{classycv@PutCoverLetterDINLetterA}%
	\fi%
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
	\ifnum\pdf@strcmp{\classycv@format}{\classycv@FORMAT@RESUME@THIRTYSEVENTY}=\z@%
		% Thirty Seventy resume format.
		\begin{classycv@PutResumeThirtySeventy}[#1]{#2}%
	\else%
		% Invalid resume format.
		\ClassWarning{classycv}{! undefined letter format (\classycv@format)}%
	\fi%
}{%
	% Close resume environment.
	\pgfkeys{/classycv/data/settings/resume/format/.get=\classycv@format}%
	\ifnum\pdf@strcmp{\classycv@format}{\classycv@FORMAT@RESUME@THIRTYSEVENTY}=\z@%
		% Thirty Seventy resume format.
		\end{classycv@PutResumeThirtySeventy}%
	\fi%
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
	% Draw included pdf.
	% Were PDF options passed?
	\ifnum\pdf@strcmp{#3}{\@empty}=\z@
		% No: don't pass to `includepdf`.
		\includepdf[pages={1-}, height=\paperheight-10mm, keepaspectratio, pagecommand={\pagestyle{attachment}}]{#4}%
	\else%
		% Yes: pass to `includepdf`.
		\includepdf[pages={1-}, height=\paperheight-10mm, keepaspectratio, pagecommand={\pagestyle{attachment}}, #3]{#4}%
	\fi%
	% Label last page (to be able to calculate the attachment page count).
	\label{attachment-\theclassycv@attachmentCounter-last-page}%
	\egroup%
}

%! NOTE private interface

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
	\vspace*{\skipAbove}\par%
	\tikz{
		\draw[use as bounding box, draw=none, inner sep=0pt] rectangle (\width, \height);%
		\path[draw, line width=\strength, color=#2] (current bounding box.west) -- (current bounding box.east);%
	}%
	\vspace*{\skipBelow}\par%
	\egroup%
}

%%
% Draw a simple horizontal progress bar.
%
% #1: (optional) Command options.
% #2: (mandatory) Completion percentage.
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
		, bar width/.get=\barWidth%
		, has label/.get=\hasLabel%
		, label width/.get=\labelWidth%
		, label position/.get=\labelPosition%
		, label font/.get=\labelFont%
		, label color/.get=\labelColor%
		, label text/.get=\labelText%		
		, label text align/.get=\labelTextAlign%
		, skip between/.get=\skipBetween%
	}%
	\setlength{\classycv@@lI}{\barWidth}%
	\divide\classycv@@lI by 100\relax%
	\multiply\classycv@@lI by #2\relax%
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
					\draw[text width=, line width=\borderWidth, draw=\borderColor, fill=\backgroundColor] (P1) rectangle +(\barWidth, \height);%
				\end{pgfonlayer}%
				\begin{pgfonlayer}{main}%
					\coordinate (P2) at ($([shift={(\skipBetween + \borderWidth, \borderWidth)}]label.south east)$);%
					\draw[draw=none, fill=\foregroundColor] (P2) rectangle +(\classycv@@lI, \height);%
				\end{pgfonlayer}%
			\else%
				\begin{pgfonlayer}{background}%
					\draw[text width=, line width=\borderWidth, draw=\borderColor, fill=\backgroundColor] (0, 0) rectangle +(\barWidth, \height);%
					\coordinate (P1) at (\barWidth, 0);%
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
					\draw[draw=none, fill=\foregroundColor] (\borderWidth, \borderWidth) rectangle +(\classycv@@lI, \height);%
				\end{pgfonlayer}%
			\fi%
		\else%
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
		%! Normalize to 360 degrees if `\arcLength` is any multiple of 360 greater than 0.
		\ifnum0 = \endDegree\relax%
			\ifnum0 < #2\relax%
				\pgfmathsetmacro\endDegree{360}%
			\fi%
		\fi%
		\setlength{\classycv@@lI}{\dimexpr0.5\size\relax}%
%		\draw[black, use as bounding box] rectangle (\size, \size);%
		\begin{pgfonlayer}{main}
		    \draw[use as bounding box, draw=\lineColor, fill=\fillColor, rotate=270, line width=\strength] (0, 0) arc (0:\endDegree:\size);%
		\end{pgfonlayer}{main}
		%! Draw a glow effect?
		\ifnum\pdf@strcmp{yes}{\drawGlow}=\z@%
			\begin{pgfonlayer}{background}
			    \draw[draw=none, fill=none, circular glow={fill=light-gray!50!nearly-white}, rotate=270] (0, 0) arc (0:360:\size);%
			\end{pgfonlayer}%
		\fi%
		%! Draw complement?
		\ifnum\pdf@strcmp{yes}{\drawComplement}=\z@%
			\begin{pgfonlayer}{overlay 1}
				\draw[draw=\complementLineColor, fill=\fillColor, line width=\strength, rotate=270] (0, 0) arc (360:\endDegree:\size);			
		    \end{pgfonlayer}%
		\fi%
		%! Draw label?
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
		, has label/.get=\hasLabel%
		, label shape/.get=\labelShape%
		, label color/.get=\labelColor%
		, label frame color/.get=\labelFrameColor%
		, label frame width/.get=\labelFrameWidth%
		, label inner sep/.get=\labelInnerSep%
		, label position/.get=\labelPosition%
		, label text/.get=\labelContent%
		, label text color/.get=\labelTextColor%
		, basic style/.get=\basicStyle%
		, text color/.get=\textColor%
		, skip above/.get=\skipAbove%
		, skip below/.get=\skipBelow%
		, skip between/.get=\skipBetween%
	}%
	\vspace*{\skipAbove}\par%
	\basicStyle%
	\setlength{\classycv@@lI}{\dimexpr\labelInnerSep+\labelFrameWidth\relax}%
	\tikz[baseline=(text.base)]{%
		\draw[use as bounding box, draw=none] rectangle (\width, \height);%
		% Is a label required?
		\ifnum\pdf@strcmp{yes}{\hasLabel}=\z@%
			% Is the label left or right?
			\ifnum\pdf@strcmp{left}{\labelPosition}=\z@%
				\node[right=\classycv@@lI of current bounding box.west, inner sep=\labelInnerSep, text width=, \labelShape, line width=\labelFrameWidth, draw=\labelFrameColor, fill=\labelColor, align=center, font={\smaller[2]}, text=\labelTextColor] (label) {\labelContent};%
				\node[
					right=\skipBetween of label.east%
					, text width=%
				] (text) {\expandafter\color\expandafter{\textColor}#2};%
			\else%
				\node[right=0pt of current bounding box.west, text width=] (text) {\expandafter\color\expandafter{\textColor}#2};%
				\node[right=\skipBetween of text.east, inner sep=\labelInnerSep, text width=, \labelShape, line width=\labelFrameWidth, draw=\labelFrameColor, fill=\labelColor, align=center, font={\smaller[2]}, text=\labelTextColor] (label) {\labelContent};%
			\fi%
		\else%
			\node[below right=0pt and 0pt of current bounding box.north west] (text) {\expandafter\color\expandafter{\textColor}#2};%
		\fi%
	}%
	\vspace*{\skipBelow}\par%
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
%		, alignment/.get=\alignment$
		, skip above/.get=\skipAbove%
		, skip below/.get=\skipBelow%
	}%
	\vspace*{\skipAbove}\par%
	\basicStyle%
	\renewcommand{\arraystretch}{\stretch}%
	%! begin tabular
	\expandafter\tabular\expandafter{\columnFormat}%
}{%
	%! end tabular
	\endtabular%
	\vspace*{\skipBelow}\par%
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
	\vspace*{\skipAbove}\par%
	\basicStyle%
	% Draw the itemize list.
	\begin{itemize}%
		\setlength{\itemsep}{\spaceBetween}%
		\setlength{\parskip}{0pt}%
		\setlength{\parsep}{0pt}%
}{%
	\end{itemize}%
	\vspace*{\skipBelow}\par%
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
	\vspace*{\skipAbove}\par%
	\basicStyle%
	{\dateLineStyle{#2}\par}%
	{\topicLineStyle{#3}\par}%
	\vspace*{\skipBetween}\par%
}{%
	\vspace*{\skipBelow}\par%
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
			\coordinate (P1) at (20mm, 0);%
			\node[above right=0pt and 0pt of P1, inner sep=0pt, outer sep=0pt, text width=170mm] {%
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
								\ifnum\pdf@strcmp{\phone}{\empty}=\z@\else{\large\Telefon}&\phone\\\fi%
								\ifnum\pdf@strcmp{\mobile}{\empty}=\z@\else{\large\faMobile}&\mobile\fi%
							\end{tabular}% 
							& \begin{tabular}[t]{C{2.5em} l}%
								\ifnum\pdf@strcmp{\email}{\empty}=\z@\else{\large\Letter}&\email\\\fi%
								\ifnum\pdf@strcmp{\website}{\empty}=\z@\else{\large\ComputerMouse}&\website\fi%
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
		, footer style/.get=\style
	}%
	\pgfkeys{/classycv/data/cover letter/DIN 5008 A/submitter/attachments/.get=\attachments}%
	% Draw component.
	\begin{tikzpicture}
		\draw[draw=none, use as bounding box] rectangle (\textwidth, 42mm);
		% Draw optional footer separator.
		\ifnum\pdf@strcmp{yes}{\hasFooterSeparator}=\z@%
			\coordinate (P1) at ($([shift={(25mm, -4.23mm)}]current bounding box.north west)$);%
			\coordinate (P2) at ($([shift={(-20mm, -4.23mm)}]current bounding box.north east)$);%
			\draw[highlight-color] (P1) -- (P2);
		\fi%
		% Draw footer content node.
		\node[below right=\dimexpr4.23mm + \baselineskip\relax and 25mm of current bounding box.north west, text width=\dimexpr\textwidth - 45mm\relax, inner sep=0pt, outer sep=0pt] (footer) {%
			\style%
			\ifnum\pdf@strcmp{yes}{\hasPageCounter}=\z@%
				\begin{tabular}[t]{L{0.9\linewidth-2\tabcolsep} R{0.1\linewidth-2\tabcolsep}}%
					% Draw attachments.
						\ifnum\pdf@strcmp{\attachments}{\empty}=\z@\else%
							\setcounter{classycv@@cI}{\the\numexpr\getpagerefnumber{cover-letter-\theclassycv@coverLetterCounter-last-page}-1}%
							\ifnum\thepage=\theclassycv@@cI%
								\faFilesO~~\attachments%
							\fi%
						\fi%
					& % Draw page counter.
						\theclassycv@coverLetterPageCounter~|~\the\numexpr\getpagerefnumber{cover-letter-\theclassycv@coverLetterCounter-last-page}-\getpagerefnumber{cover-letter-\theclassycv@coverLetterCounter-first-page}%
				\end{tabular}%
			\else%
				\ifnum\pdf@strcmp{\attachments}{\empty}=\z@\else%
					\setcounter{classycv@@cI}{\the\numexpr\getpagerefnumber{cover-letter-\theclassycv@coverLetterCounter-last-page}-1}%
					\ifnum\thepage=\theclassycv@@cI%
						\stackbox[l]{\faFilesO~~\attachments}%
					\fi%
				\fi%
			\fi%
		};%
	\end{tikzpicture}
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
	\ifnum\pdf@strcmp{\attachments}{\empty}=\z@\else%
		% Yes: put attachments line.
		\pgfkeys{/classycv/data/cover letter/DIN 5008 A/options/attachments style/.get=\attachmentsStyle}%
		\vfill%
		{\attachmentsStyle\faFilesO~~\attachments}%
	\fi%
	\egroup%
}

% TODO remove?
\iffalse
%
%! Fourty Sixty resume format.
%
\newenvironment{classycv@PutResumeFourtySixty}[2][]{%
	\bgroup%
	%! Set data
	\pgfkeys{/classycv/data/resume/Fourty Sixty/options/.cd, #1}
	\pgfkeys{/classycv/data/resume/Fourty Sixty/.cd, #2}%
	%! Define default components
	\@ifundefined{/classycv/components/resume/picture}{\classycvDefineComponent{/resume/picture}{\classycv@PutResumeFourtySixty@pictureComponent}}{}
	\@ifundefined{/classycv/components/resume/title}{\classycvDefineComponent{/resume/title}{\classycv@PutResumeFourtySixty@titleComponent}}{}
	\@ifundefined{/classycv/components/resume/content}{\classycvDefineComponent{/resume/title}{\classycv@PutResumeFourtySixty@titleComponent}}{}%	
	%! Set geometry and page style
	\loadgeometry{blank}%
	\pagestyle{blank}
	%! Set indentation to zero.
	\setlength{\parindent}{0pt}%
	%! 
	\begin{minipage}[t]{0.4\paperwidth}
%
%!todo: content
%
	\end{minipage}%
	%! put right page side
	\begin{minipage}[t]{0.6\paperwidth}%
    %! Put title
    \classycv@PutComponent{/resume/title}%
}{%
	\end{minipage}%
	%! Restore geometry, page style
	\clearpage
	\restoregeometry%
	\pagestyle{blank}%
	%! Restore indentation.
	\setlength{\parindent}{\classycv@parindent@default}%
	%! Clear page
	% NOTE `\clearpage` is necessary for geometry and page style to be applied
	%!ref: http://tex.stackexchange.com/a/115418
	\clearpage%
	\egroup%
}

\newcommand{\classycv@PutResumeFourtySixty@pictureComponent}{%
	%! Get data
	\pgfkeys{/classycv/data/resume/Fourty Sixty/picture/.get=\picture}%
	%! Put component
	\adjustbox{margin=10mm 0pt 0pt 10mm, minipage={\linewidth-10mm}}{%
		\ifnum\pdf@strcmp{\picture}{\@empty}=\z@%
		\else%
			\adjustbox{minipage={\linewidth}, bgcolor=light-gray}{%
				\begin{center}%
					\includegraphics[width=0.5\linewidth, keepaspectratio]{\picture}%
				\end{center}%
			}%
		\fi%
	}%
	\vspace*{24pt}\par%
}

\newcommand{\classycv@PutResumeFourtySixty@titleComponent}{%
	%! Get data
	\pgfkeys{/classycv/data/resume/Thirty Seventy/name/.get=\name}%
	%! Put component
	\Huge\color{nearly-white}\MakeUppercase{\name}\par%
	%! Put delimiter
	\classycv@Resume@PutDelimiter{nearly-white}%
}
\fi

%%
% Thirty Seventy resume format.
%
% #1, #2: see environment "Resume".
%%
\newenvironment{classycv@PutResumeThirtySeventy}[2][]{%
	\bgroup%
	% Gather options and parameters.
	\pgfkeys{/classycv/data/resume/Thirty Seventy/options/.cd, #1}%
	\pgfkeys{/classycv/data/resume/Thirty Seventy/.cd, #2}%
	\pgfkeys{%
		/classycv/data/resume/Thirty Seventy/options/.cd%
		, right basic style/.get=\rightStyle%
		, right foreground color/.get=\rightFg%
		, delimiter color/.get=\delimiterColor%
	}%
	% Define default components
	\@ifundefined{/classycv/components/resume/left}{\classycvDefineComponent{/resume/left}{\classycv@PutResumeThirtySeventy@leftComponent}}{}%
	\@ifundefined{/classycv/components/resume/left/picture}{\classycvDefineComponent{/resume/left/picture}{\classycv@PutResumeThirtySeventy@left@pictureComponent}}{}%
	\@ifundefined{/classycv/components/resume/left/personal data}{\classycvDefineComponent{/resume/left/personal data}{\classycv@PutResumeThirtySeventy@left@personalDataComponent}}{}%
	\@ifundefined{/classycv/components/resume/left/contact data}{\classycvDefineComponent{/resume/left/contact data}{\classycv@PutResumeThirtySeventy@left@contactDataComponent}}{}%
	\@ifundefined{/classycv/components/resume/left/extra data}{\classycvDefineComponent{/resume/left/extra data}{\classycv@PutResumeThirtySeventy@left@extraDataComponent}}{}%
	% Set left component width.
	\setlength{\classycv@@lI}{\dimexpr0.7\textwidth}%
	\setlength{\classycv@@lII}{\dimexpr0.3\textwidth}%
	\setlength{\classycv@@lIII}{\dimexpr\paperheight-\dimexpr\classycv@GEOMETRY@BLANK@TMARGIN+\classycv@GEOMETRY@BLANK@TMARGIN}%
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
		, leftupper=\dimexpr\classycv@@lII+\dimexpr2\classycv@GEOMETRY@BLANK@LMARGIN\relax%
		% Add slight padding.
		, boxsep=2em%
        , width=\textwidth%
        , height fixed for=all%
        , height fill=true%
        , breakable%
        , break at=\textheight%
        % Draw left page side as overlay.
		, overlay unbroken and first={%	
			\draw[draw=none, use as bounding box] rectangle (\classycv@@lII, \classycv@@lIII);%
			\node[draw=none, text width=\classycv@@lII, below right=0pt and 0pt of current bounding box.north west, outer sep=0pt, inner sep=0pt]{%
				\classycv@PutComponent{/resume/left}%
			};%
			% Draw delimiting vertical line.
			\draw[draw=\delimiterColor, very thick, opacity=0.25] (\dimexpr\classycv@@lII+\classycv@GEOMETRY@BLANK@LMARGIN, \classycv@GEOMETRY@BLANK@LMARGIN) -- (\dimexpr\classycv@@lII+\classycv@GEOMETRY@BLANK@LMARGIN, \dimexpr\classycv@@lIII-\classycv@GEOMETRY@BLANK@LMARGIN);%
		}%
		, overlay middle and last={%
			\draw[draw=none, use as bounding box] rectangle (\classycv@@lII, \classycv@@lIII);%
			\node[draw=none, text width=\classycv@@lII, below right=0pt and 0pt of current bounding box.north west, outer sep=0pt, inner sep=0pt]{%
				\classycv@PutComponent{/resume/left}%
			};%
			% Draw delimiting vertical line.
			\draw[draw=\delimiterColor, very thick, opacity=0.25] (\dimexpr\classycv@@lII+\classycv@GEOMETRY@BLANK@LMARGIN, \classycv@GEOMETRY@BLANK@LMARGIN) -- (\dimexpr\classycv@@lII+\classycv@GEOMETRY@BLANK@LMARGIN, \dimexpr\classycv@@lIII-\classycv@GEOMETRY@BLANK@LMARGIN);%
		}%
	]%
	\bgroup\expandafter\color\expandafter{\rightFg}\rightStyle%
}{%
	\egroup%
	\vfill%
	\end{tcolorbox}%
	% Restore indentation.
	\setlength{\parindent}{\classycv@parindent@default}%
	\clearpage%
	\egroup%
}

%%
% Thirty Seventy resume format default left component. 
%%
\newcommand{\classycv@PutResumeThirtySeventy@leftComponent}{%
	\bgroup%
	\pgfkeys{%
		/classycv/data/resume/Thirty Seventy/.cd%
		, picture/.get=\picture%
		, name/.get=\name%
		, title/.get=\title%
	}%
	\pgfkeys{%
		/classycv/data/resume/Thirty Seventy/options/.cd%
		, left foreground color/.get=\righFg%
		, left basic style/.get=\style%
	}%
	\style\expandafter\color\expandafter{\rightFg}%
	\begin{center}%
		% Picture (optional).
		\ifnum\pdf@strcmp{\@empty}{\picture}=\z@%
			\vspace*{4em}\par%
		\else%
			\classycv@PutComponent{/resume/left/picture}%
			\vspace*{2em}\par%
		\fi%
		% Draw title.
		{\larger[3]\bfseries\name}\\
		\ifnum\pdf@strcmp{\@empty}{\title}=\z@\else\larger[2]\fontseries{l}\selectfont\title\\\fi%
		% Draw personal data.
		\classycv@PutComponent{/resume/left/personal data}%
		% Draw contact data.
		\classycv@PutComponent{/resume/left/contact data}%
		% Draw extra data (optional).
		\classycv@PutComponent{/resume/left/extra data}%
	\end{center}%
	\egroup%
}

%%
% Thirty Seventy resume format default picture component. 
%%
\newcommand{\classycv@PutResumeThirtySeventy@left@pictureComponent}{%
	\bgroup%
	\pgfkeys{/classycv/data/resume/Thirty Seventy/picture/.get=\picture}%
	\includegraphics[width=\linewidth]{\picture}%
	\egroup%
}
%%
% Thirty Seventy resume format default personal data component for left side.
%%
\newcommand{\classycv@PutResumeThirtySeventy@left@personalDataComponent}{%
	\bgroup%
	\pgfkeys{/classycv/data/resume/Thirty Seventy/personal data heading text/.get=\text}%
	% Put picture.
	\pgfkeys{%
		/classycv/data/resume/Thirty Seventy/.cd%
		, birthdate/.get=\birthdate%
		, marital status/.get=\status%
		, nationality/.get=\nationality%
	}%
	\pgfkeys{%
		/classycv/data/resume/Thirty Seventy/options/.cd%
		, left foreground color/.get=\fg%
		, left header style/.get=\leftHeaderStyle%
		, left entry style/.get=\leftEntryStyle%
	}%
	% Put personal data.
	\heading[%
		width=\dimexpr\linewidth-24pt\relax%
		, has label=yes%
		, label position=left%
		, label text={\faUser}%
		, skip above=2em%
		, skip below=0em%
		, label color=accent-color%
		, label frame color=accent-color%
		, label text color=nearly-white%
		, basic style=\leftHeaderStyle%
	] {\text}
	\begin{Table}[%
		skip above=1em%
		, skip below=0em%
		, column format={C{2em} p{\linewidth-24pt-2em-3\tabcolsep}}%
		, basic style=\leftEntryStyle%
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
	\egroup%
}

%%
% Thirty Seventy resume format default contact data component for left side.
%%
\newcommand{\classycv@PutResumeThirtySeventy@left@contactDataComponent}{%
	\pgfkeys{/classycv/data/resume/Thirty Seventy/contact data heading text/.get=\text}%
	\pgfkeys{%
		/classycv/data/resume/Thirty Seventy/.cd%
		, phone/.get=\phone%
		, mobile/.get=\mobile%
		, email/.get=\email%
		, website/.get=\website%
	}%
	\pgfkeys{%
		/classycv/data/resume/Thirty Seventy/options/.cd%
		, left foreground color/.get=\fg%
		, left header style/.get=\leftHeaderStyle%
		, left entry style/.get=\leftEntryStyle%		
	}%
	\heading[%
		width=\dimexpr\linewidth-24pt\relax%
		, has label=yes%
		, label position=left%
		, label text={\faComments}%
		, skip above=2em%
		, skip below=0em%
		, label color=accent-color%
		, label frame color=accent-color%
		, label text color=nearly-white%
		, basic style=\leftHeaderStyle%
	] {\text}
	\begin{Table}[%
		skip above=1em%
		, skip below=0em%
		, column format={C{2em} p{\linewidth-24pt-2em-3\tabcolsep}}%
		, basic style=\leftEntryStyle%
	]%	
		\ifnum\pdf@strcmp{\phone}{\@empty}=\z@\else{\larger[2]\cmbrfamily\Telefon}&\phone\\\fi%
		\ifnum\pdf@strcmp{\mobile}{\@empty}=\z@\else{\larger[2]\cmbrfamily\faMobile}&\mobile\\\fi%
		\ifnum\pdf@strcmp{\email}{\@empty}=\z@\else{\larger[2]\cmbrfamily\Letter}&\email\\\fi%
		\ifnum\pdf@strcmp{\website}{\@empty}=\z@\else{\larger[2]\cmbrfamily\ComputerMouse}&\website\fi%
	\end{Table}%
}

%%
% Thirty Seventy resume format default extra dat component for left side.
%%
\newcommand{\classycv@PutResumeThirtySeventy@left@extraDataComponent}{}%

% TODO remove?
\iffalse
%
%! Twenty Eighty resume format.
%
\newenvironment{classycv@PutResumeTwentyEighty}[2][]{%
	\bgroup%
	%! Set data
	\pgfkeys{/classycv/data/resume/Twenty Eighty/options/.cd, #1}
	\pgfkeys{/classycv/data/resume/Twenty Eighty/.cd, #2}%
	%! Define default components
	\@ifundefined{/classycv/components/resume/picture}{\classycvDefineComponent{/resume/picture}{\classycv@PutResumeTwentyEighty@pictureComponent}}{}
	\@ifundefined{/classycv/components/resume/information}{\classycvDefineComponent{/resume/information}{\classycv@PutResumeTwentyEighty@informationComponent}}{}
	\@ifundefined{/classycv/components/resume/contact}{\classycvDefineComponent{/resume/contact}{\classycv@PutResumeTwentyEighty@contactComponent}}{}
	\@ifundefined{/classycv/components/resume/extra}{\classycvDefineComponent{/resume/extra}{\classycv@PutResumeTwentyEighty@extraComponent}}{}%
	\@ifundefined{/classycv/components/resume/title}{\classycvDefineComponent{/resume/title}{\classycv@PutResumeTwentyEighty@titleComponent}}{}%
	%! Set geometry and page style; clear page.
	\loadgeometry{blank}%
	\pagestyle{blank}%
	\clearpage%
	%! Set indentation to zero.
	\setlength{\parindent}{0pt}%
    \begin{tcolorbox}[%
        blanker%
        , leftupper=0.2\paperwidth%
        , boxsep=24pt%
        , width=\paperwidth%
        , height fill=true%
        , height fixed for=all%
        , breakable%
        , break at=\textheight%
        %! Put left page side as overlay.
        , overlay unbroken and first={%
			\pgfkeys{%
				/classycv/data/resume/Twenty Eighty/options/.cd%
				, left background color/.get=\bg%
				, left foreground color/.get=\fg%
			}%
            \draw[use as bounding box, inner sep=0pt, outer sep=0pt, draw=none, fill=\bg] (0, 0) rectangle (0.2\paperwidth, \paperheight);%
            \node[draw=none, inner sep=0pt, outer sep=0pt, text width=0.2\paperwidth, below right=0pt and 0pt of current bounding box.north west]{%
                \classycv@PutComponent{/resume/picture}%
                \classycv@PutComponent{/resume/information}%
                \classycv@PutComponent{/resume/contact}%
            };%
        }%
        , overlay middle and last={%
			\pgfkeys{%
				/classycv/data/resume/Twenty Eighty/options/.cd%
				, left background color/.get=\bg%
				, left foreground color/.get=\fg%
			}%
            \draw[use as bounding box, inner sep=0pt, outer sep=0pt, draw=none, fill=\bg] (0, 0) rectangle (0.2\paperwidth, \paperheight);%
            \node[rotate=90, inner sep=0pt, outer sep=0pt, minimum width=\paperheight, minimum height=0.3\paperwidth, text width=\paperheight, anchor=north west, align=center] {%
                \pgfkeys{/classycv/data/resume/Thirty Seventy/name/.get=\name}%
                \bgroup%
                    \color{nearly-white}\bfseries\fontsize{84pt}{92pt}\selectfont\name%
                \egroup%
            };%
        }%
    ]%
    %
    %! Put right page side.
    %
    %! Apply content style.
    \csname/classycv/style/resume/content\endcsname\relax%
    %! Put title
    \classycv@PutComponent{/resume/title}%
}{%
	\end{tcolorbox}%
	%! Restore indentation.
	\setlength{\parindent}{\classycv@parindent@default}%
	\egroup%
}

%
%! Twenty Eighty resume format default components. 
%

\newcommand{\classycv@PutResumeTwentyEighty@pictureComponent}{%
	\bgroup%
	%! put picture
	\pgfkeys{/classycv/data/resume/Twenty Eighty/picture/.get=\picture}%
	\ifnum\pdf@strcmp{\picture}{\@empty}=\z@%
	\else%
%		\vspace*{24pt}\par%
		\centerline{%
			\tcbox[boxsep=0pt, width=\linewidth, left=0pt, bottom=0pt, right=0pt, top=0pt, leftrule=0pt, bottomrule=0pt, rightrule=0pt, toprule=0pt, colframe=light-gray, sharp corners, standard jigsaw, opacityback=0]{%
				\tikz[opacity=0.95]{%
					\node{\includegraphics[width=\dimexpr0.75\linewidth\relax, keepaspectratio]{\picture}}%
				}%
			}%
		}%
		\vspace*{24pt}\par
	\fi%
	\egroup%
}

\newcommand{\classycv@PutResumeTwentyEighty@informationComponent}{%
	\bgroup%
	%! put personal data
	\pgfkeys{
		/classycv/data/resume/Twenty Eighty/.cd%
		, birthdate/.get=\birthdate%
		, marital status/.get=\status%
		, nationality/.get=\nationality%
	}%
	\adjustbox{margin=12pt 12pt 12pt 0pt, minipage=\linewidth-24pt}{%
		%! Style put before this component is being ignored and hence has to be restated here.
		\@ifundefined{/classycv/style/resume/information}{}{\csname/classycv/style/resume/information\endcsname}%
		%! Put the heading
		\classycv@tResume@heading[\raggedleft][\smallskip][]{\color{light-gray}\normalsize\faUser}%
		%! Put the delimiter
		\classycv@Resume@PutDelimiter[\linewidth][10pt][2pt]{nearly-white}%
		%! Put content table
		\setlength{\tabcolsep}{0pt}%
		\begin{tabularx}{\linewidth}{M{24pt} X}%
			\ifnum\pdf@strcmp{\birthdate}{\@empty}=\z@\else{\cmrfamily\large\textborn}&\birthdate\\[0.5em]\fi%
			\ifnum\pdf@strcmp{\status}{\@empty}=\z@\else{\cmrfamily\large\textmarried}&\status\\[0.5em]\fi%
			\ifnum\pdf@strcmp{\nationality}{\@empty}=\z@\else{\large\Mundus}&\nationality\\\fi%
		\end{tabularx}%
		\setlength{\tabcolsep}{\classycv@tabcolsep@default}%
	}%
	\par%
	\egroup%
}

\newcommand{\classycv@PutResumeTwentyEighty@contactComponent}{%
	\bgroup%
	\pgfkeys{
		/classycv/data/resume/Twenty Eighty/.cd%
		, phone/.get=\phone%
		, mobile/.get=\mobile%
		, email/.get=\email%
		, website/.get=\website%
	}%
	%! put contact data
	\adjustbox{margin=12pt 12pt 12pt 0pt, minipage=\linewidth-24pt}{%
		%! Style put before this component is being ignored and hence has to be restated here.
		\@ifundefined{/classycv/style/resume/information}{}{\csname/classycv/style/resume/information\endcsname}%
		%! Put heading
		\classycv@Resume@PutHeading[\raggedleft][][]{\color{light-gray}\normalsize\faCommentsO}%
		%! Put delimiter
		\classycv@Resume@PutDelimiter[\linewidth][10pt][2pt]{nearly-white}%
		%! Put content table
		\setlength{\tabcolsep}{0pt}
		\begin{tabularx}{\linewidth}{M{24pt} X}
			\ifnum\pdf@strcmp{\phone}{\@empty}=\z@\else{\large\Telefon}&\phone\\[0.5em]\fi%
			\ifnum\pdf@strcmp{\mobile}{\@empty}=\z@\else{\large\faMobile}&\mobile\\[0.5em]\fi%
			\ifnum\pdf@strcmp{\email}{\@empty}=\z@\else{\large\Letter}&\email\\[0.5em]\fi%
			\ifnum\pdf@strcmp{\website}{\@empty}=\z@\else{\large\ComputerMouse}&\website\fi%
		\end{tabularx}%
		\setlength{\tabcolsep}{\classycv@tabcolsep@default}
	}%
	\par%
	\egroup%
}

\newcommand{\classycv@PutResumeTwentyEighty@extraComponent}{%
\relax%
}

\newcommand{\classycv@PutResumeTwentyEighty@titleComponent}{%
	%! Get data
	\pgfkeys{/classycv/data/resume/Thirty Seventy/name/.get=\name}%
	%! Put component
	\Huge\color{nearly-white}\MakeUppercase{\name}\par%
	%! Put delimiter
	\classycv@Resume@PutDelimiter{nearly-white}%
}
\fi

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
		, submitter name/.get=\submitterName%
		, attachment name/.get=\attachmentName%
	}%
	\pgfkeys{%
		/classycv/data/attachment/options/.cd%
		, has page counter/.get=\hasPageCounter%
		, background color/.get=\bg%
		, foreground color/.get=\fg%
		, text style/.get=\textStyle%
	}%
	\setlength{\classycv@@lI}{\dimexpr\paperwidth-\dimexpr\classycv@GEOMETRY@BLANK@LMARGIN+\classycv@GEOMETRY@BLANK@RMARGIN}%
	\setlength{\classycv@@lII}{\dimexpr20mm}%
	\tikz{%
		\draw[use as bounding box, draw=none] rectangle (\paperwidth, 20mm);%
		\draw[draw=highlight-color, thick, opacity=0.5] (\classycv@GEOMETRY@BLANK@LMARGIN, \classycv@@lII) -- (\classycv@@lI, \classycv@@lII);%
		\node[minimum width=\classycv@@lI, text width=\classycv@@lI, inner sep=0pt, outer sep=0pt, below right=\classycv@GEOMETRY@BLANK@BMARGIN and \classycv@GEOMETRY@BLANK@LMARGIN of current bounding box.north west]{%
			\begin{tabular}{m{0.9\dimexpr\linewidth-24pt\relax-\tabcolsep} R{0.1\dimexpr\linewidth-24pt\relax-\tabcolsep}}%
				\ifnum\pdf@strcmp{\@empty}{\attachmentName}=\z@\else%
					\textStyle{\bfseries\faFilesO}~\attachmentName%
				\fi%
				& \ifnum\pdf@strcmp{yes}{\hasPageCounter}=\z@%
					\setcounter{classycv@@cI}{\getpagerefnumber{attachment-\theclassycv@attachmentCounter-first-page}}%
					\setcounter{classycv@@cII}{\getpagerefnumber{attachment-\theclassycv@attachmentCounter-last-page}}%
					\textStyle\number\numexpr1 + \thepage - \theclassycv@@cI\relax~|~\number\numexpr\theclassycv@@cII-\theclassycv@@cI\relax%
				\fi%
			\end{tabular}%
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
	, height/.initial=1em%
	, height/.default=1em%
	, background color/.initial=accent-color!25!nearly-white%
	, background color/.default=accent-color!25!nearly-white%
	, foreground color/.initial=accent-color%
	, foreground color/.default=accent-color%	
	, bar width/.initial=\linewidth%
	, bar width/.default=\linewidth%
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
	, width/.initial=\dimexpr\linewidth-24pt\relax%
	, width/.default=\dimexpr\linewidth-24pt\relax%
	, height/.initial=2em%
	, height/.default=2em%
	, has label/.initial=no%
	, has label/.default=no%
	, label shape/.initial=circle%
	, label shape/.default=circle%
	, label width/.initial=1.25em%
	, label width/.default=1.25em%
	, label color/.initial=highlight-color%
	, label color/.default=highlight-color%
	, label frame color/.initial=highlight-color%
	, label frame color/.default=highlight-color%
	, label frame width/.initial=0pt%
	, label frame width/.default=0pt%
	, label inner sep/.initial=4pt%
	, label inner sep/.default=4pt%
	, label text color/.initial=nearly-white%
	, label text color/.default=nearly-white%
	, label position/.initial=left%
	, label position/.default=left%
	, label options/.initial=\@empty%
	, label options/.default=\@empty%
	, label text/.initial=\@empty%
	, label text/.default=\@empty%
	, basic style/.initial={\flafamily\larger[2]\bfseries}%
	, basic style/.default={\flafamily\larger[2]\bfseries}%
	, text color/.initial=accent-color%
	, text color/.default=accent-color%
	, skip above/.initial=1em%
	, skip above/.default=1em%	
	, skip below/.initial=2em%
	, skip below/.default=2em%
	, skip between/.initial=1em%
	, skip between/.default=1em%	
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
	, basic style/.initial={\lmrfamily\normalsize\mdseries}%
	, basic style/.default={\lmrfamily\normalsize\mdseries}%
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
	, basic style/.initial={\lmrfamily\normalsize}%
	, basic style/.default={\lmrfamily\normalsize}%
	, date line style/.initial={\robotofamily\normalsize\bfseries}
	, date line style/.default={\robotofamily\normalsize\bfseries}
	, topic line style/.initial={\robotofamily\normalsize\fontseries{l}\selectfont}
	, topic line style/.default={\robotofamily\normalsize\fontseries{l}\selectfont}
%	, alignment/.initial=c%
%	, alignment/.default=c%
	, skip above/.initial=1em%
	, skip above/.default=1em%
	, skip between/.initial=1em%
	, skip between/.default=1em%
	, skip below/.initial=0em%
	, skip below/.default=0em%	
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
%	, attachments style/.initial={\robotofamily\fontseries{l}\selectfont\normalsize\color{medium-gray}}%
%	, attachments style/.default={\robotofamily\fontseries{l}\selectfont\normalsize\color{medium-gray}}%
	, footer style/.initial={\robotofamily\small\mdseries}
	, footer style/.default={\robotofamily\small\mdseries}
}

\pgfkeys{%
	/classycv/data/cover letter/DIN 5008 A/submitter/.cd%
	, title/.initial=\@empty%
	, title/.default=\@empty%
	, name/.initial=\@empty%
	, name/.default=\@empty%
	, organisation/.initial=\@empty%
	, organisation/.default=\@empty%
	, position/.initial=\@empty%
	, position/.default=\@empty%
	, street/.initial=\@empty%
	, street/.default=\@empty%
	, house/.initial=\@empty%
	, house/.default=\@empty%
	, zipcode/.initial=\@empty%	
	, zipcode/.default=\@empty%	
	, city/.initial=\@empty%
	, city/.default=\@empty%	
	, country/.initial=\@empty%
	, country/.default=\@empty%
	, phone/.initial=\@empty%
	, phone/.default=\@empty%	
	, mobile/.initial=\@empty%
	, mobile/.default=\@empty%
	, fax/.initial=\@empty%
	, fax/.default=\@empty%
	, email/.initial=\@empty%
	, email/.default=\@empty%	
	, website/.initial=\@empty%
	, website/.default=\@empty%
	, sign/.initial=\@empty%
	, sign/.default=\@empty%
	, reply sign/.initial=\@empty%
	, reply sign/.default=\@empty%
	, original sign/.initial=\@empty%
	, original sign/.default=\@empty%	
	, date/.initial=\@empty%
	, date/.default=\@empty%	
	, reply message date/.initial=\@empty%
	, reply message date/.default=\@empty%	
	, original message date/.initial=\@empty%
	, original message date/.default=\@empty%
	, attachments/.initial=\@empty%
	, attachments/.default=\@empty%	
}

\pgfkeys{%
	/classycv/data/cover letter/DIN 5008 A/recipient/.cd%
	, rta/.initial=\@empty%
	, title/.initial=\@empty%
	, name/.initial=\@empty%
	, organisation/.initial=\@empty%
	, position/.initial=\@empty%
	, street/.initial=\@empty%
	, house/.initial=\@empty%
	, zipcode/.initial=\@empty%	
	, city/.initial=\@empty%
	, country/.initial=\@empty%
}	

\pgfkeys{%
	/classycv/data/cover letter/DIN 5008 A/.cd%
	, date/.initial=\today%
	, date/.default=\today%
	, subject/.initial=\@empty%
	, subject/.default=\@empty%
	, opening/.initial=\@empty%
	, opening/.default=\@empty%
	, closing/.initial=\@empty%
	, closing/.default=\@empty%
}%

\pgfkeys{%
	/classycv/data/settings/resume/.cd%
	, format/.initial=\classycv@FORMAT@RESUME@THIRTYSEVENTY%
	, format/.default=\classycv@FORMAT@RESUME@THIRTYSEVENTY%	
}

\pgfkeys{%
	/classycv/data/resume/Fourty Sixty/options/.cd%
	, left background color/.initial=accent-color
	, left background color/.default=accent-color
	, left foreground color/.initial=nearly-white
	, left foreground color/.default=nearly-white
}

\pgfkeys{%
	/classycv/data/resume/Fourty Sixty/.cd%
	, picture/.initial=\@empty%
	, name/.initial=\@empty%
	, birthdate/.initial=\@empty%
	, marital status/.initial=\@empty%
	, nationality/.initial=\@empty%
	, phone/.initial=\@empty%
	, mobile/.initial=\@empty%
	, email/.initial=\@empty%
	, website/.initial=\@empty%
}

\pgfkeys{%
	/classycv/data/resume/Thirty Seventy/.cd%
	, picture/.initial=\@empty%
	, picture/.default=\@empty%
	, name/.initial=\@empty%
	, name/.default=\@empty%
	, title/.initial=\@empty%
	, title/.default=\@empty%
	, street/.initial=\@empty%
	, street/.default=\@empty%
	, house/.initial=\@empty%
	, house/.default=\@empty%
	, zipcode/.initial=\@empty%
	, zipcode/.default=\@empty%
	, city/.initial=\@empty%
	, city/.default=\@empty%
	, country/.initial=\@empty%
	, country/.default=\@empty%
	, birthdate/.initial=\@empty%
	, birthdate/.default=\@empty%
	, marital status/.initial=\@empty%
	, marital status/.default=\@empty%
	, nationality/.initial=\@empty%
	, nationality/.default=\@empty%
	, phone/.initial=\@empty%
	, phone/.default=\@empty%
	, mobile/.initial=\@empty%
	, mobile/.default=\@empty%
	, email/.initial=\@empty%
	, email/.default=\@empty%
	, website/.initial=\@empty%
	, website/.default=\@empty%
	, personal data heading text/.initial=\@empty%
	, personal data heading text/.default=\@empty%
	, contact data heading text/.initial=\@empty%
	, contact data heading text/.default=\@empty%
	, submitter information basic style/.initial={}%
	, submitter information basic style/.default={}%
}

\pgfkeys{%
	/classycv/data/resume/Thirty Seventy/options/.cd%
	, left basic style/.initial={\robotofamily\fontseries{l}\selectfont\small}%
	, left basic style/.default={\robotofamily\fontseries{l}\selectfont\small}%
	, left foreground color/.initial=highlight-color%
	, left foreground color/.default=highlight-color%
%	, left name style/.initial={\flafamily\larger[2]\mdseries\scshape\color{highlight-color}}%
%	, left name style/.default={\flafamily\larger[2]\mdseries\scshape\color{highlight-color}}%	
%	, left title style/.initial={\flafamily\fontseries{l}\selectfont\larger\color{highlight-color}}%
%	, left title style/.default={\flafamily\fontseries{l}\selectfont\larger\color{highlight-color}}%	
	, left address style/.initial={\flafamily\fontseries{l}\selectfont\larger}%
	, left address style/.default={\flafamily\fontseries{l}\selectfont\larger}%
	, left header style/.initial={\flafamily\mdseries\large}%
	, left header style/.default={\flafamily\mdseries\large}%
	, left header skip before/.initial={\bigskip}%
	, left header skip before/.default={\bigskip}%
	, left entry style/.initial={\robotofamily\fontseries{l}\selectfont\small}%
	, left entry style/.default={\robotofamily\fontseries{l}\selectfont\small}%
	, left entry skip above/.initial={}%
	, left entry skip above/.default={}%
	, left entry skip below/.initial={\smallskip}%
	, left entry skip below/.default={\smallskip}%
%	, left additional personal data/.initial=\@empty%
%	, left additional personal data/.default=\@empty%
%	, left additional contact data/.initial=\@empty%
%	, left additional contact data/.default=\@empty%
	, right basic style/.initial={\robotofamily\fontseries{l}\selectfont\normalsize}%
	, right basic style/.default={\robotofamily\fontseries{l}\selectfont\normalsize}%	
	, right foreground color/.initial=black%
	, right foreground color/.default=black%
%	, content lines style/.initial={\lmrfamily\larger}%
%	, content lines style/.default={\lmrfamily\fontseries{l}\selectfont\larger}%
	, delimiter color/.initial=highlight-color
	, delimiter color/.default=highlight-color
}

% TODO remove?
\iffalse
%
%! Twenty Eighty resume data
%
\pgfkeys{%
	/classycv/data/resume/Twenty Eighty/options/.cd%
	, left background color/.initial=accent-color%
	, left background color/.default=accent-color%
	, left foreground color/.initial=nearly-white%
	, left foreground color/.default=nearly-white%
}

\pgfkeys{%
	/classycv/data/resume/Twenty Eighty/.cd%
	, picture/.initial=\@empty%
	, name/.initial=\@empty%
	, birthdate/.initial=\@empty%
	, marital status/.initial=\@empty%
	, nationality/.initial=\@empty%
	, phone/.initial=\@empty%
	, mobile/.initial=\@empty%
	, email/.initial=\@empty%
	, website/.initial=\@empty%
}
\fi 

%
%! Attachment data
%
\pgfkeys{%
	/classycv/data/attachment/.cd%
	, submitter name/.initial=\@empty%
	, attachment name/.initial=\@empty%
}

\pgfkeys{%
	/classycv/data/attachment/options/.cd%
	, has page counter/.initial=yes%
	, background color/.initial=accent-color%
	, background color/.default=accent-color%
	, foreground color/.initial=highlight-color%
	, foreground color/.default=highlight-color%
	, text style/.initial={\robotofamily}%
	, text style/.default={\robotofamily}%
}


% NOTE Page geometry definitions.

\geometry{}
\savegeometry{default}

%%
% Blank page geomtery with margins are added for printing.
%%
\newlength{\classycv@GEOMETRY@BLANK@TMARGIN}
\setlength{\classycv@GEOMETRY@BLANK@TMARGIN}{5mm}
\newlength{\classycv@GEOMETRY@BLANK@RMARGIN}
\setlength{\classycv@GEOMETRY@BLANK@RMARGIN}{5mm}
\newlength{\classycv@GEOMETRY@BLANK@BMARGIN}
\setlength{\classycv@GEOMETRY@BLANK@BMARGIN}{5mm}
\newlength{\classycv@GEOMETRY@BLANK@LMARGIN}
\setlength{\classycv@GEOMETRY@BLANK@LMARGIN}{5mm}

\newgeometry{%
	% Ignore header, footer, margin par
	noheadfoot%
	, nomarginpar%
	, ignoreall%
	, width=\paperwidth%
	, height=\paperheight%
%	, headheight=0pt%
	, tmargin=\classycv@GEOMETRY@BLANK@TMARGIN%
	, rmargin=\classycv@GEOMETRY@BLANK@RMARGIN%
	, bmargin=\classycv@GEOMETRY@BLANK@BMARGIN%
	, lmargin=\classycv@GEOMETRY@BLANK@LMARGIN%
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
% Attachment geometry.
%%
\newgeometry{%
	includeheadfoot%
	, nomarginpar%
	, headheight=0pt%
	, headsep=0pt%
	, foot=0pt%
	, footskip=0mm%
	, bmargin=20mm%
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

\AtEndDocument{%
\cleardoublepage%
\clearpage%
\newpage%
\pagestyle{empty}%
\vspace*{\fill}%
	\begin{center}
		\Huge\flafamily\fontseries{l}\selectfont Made with package \textcolor{accent-color}{\bfseries classycv} for \LaTeX2e
	\end{center}%
\vspace*{\fill}%
}
