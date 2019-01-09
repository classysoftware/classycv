\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{classycv}[2018/10/30 A LaTeX class for classy CVs]

% Extend article class (see http://stackoverflow.com/a/587054)
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions
\LoadClass{article}

\RequirePackage{pgfkeys}

\makeatletter

\pgfkeys{%
  /classycv/submitter/.cd%
  , name/.initial=\@empty%
  , street/.initial=\@empty%
  , house/.initial=\@empty%
  , city/.initial=\@empty%
  , zipcode/.initial=\@empty%
  , country/.initial=\@empty%
  , countrycode/.initial=\@empty%
  , phone/.initial=\@empty%
  , email/.initial=\@empty%
  , website/.initial=\@empty%
  , additional/.initial=\@empty%
}

\pgfkeys{%
  /classycv/recipient/.cd%
  , name/.initial=\@empty%
  , position/.initial=\@empty%
  , company/.initial=\@empty%
  , street/.initial=\@empty%
  , house/.initial=\@empty%
  , city/.initial=\@empty%
  , zipcode/.initial=\@empty%
  , company/.initial=\@empty%
  , country/.initial=\@empty%
}

\pgfkeys{%
  /classycv/attachment/.cd%
  , title/.initial=\@empty%
}

%%
% Use a classycv library
% #1: [Optional] Package options for the library file which should be included.
% #2: Library name (adding the prefix "classycvlibrary" to this must generate the name of the ".sty" file to include)-
%%
\newcommand{\classycvuselibrary}[2][]{%
  \usepackage[#1]{classycvlibrary#2}%
}

%%
% Select a theme
% #1: [Optional] Modifier for inner themes (potential values: "coverletter", "resume")
% #2: Theme name (adding the prefix "classycvtheme" to this must generate the name of the ".sty" file to include).
%%
\newcommand{\classycvusetheme}[2][]{%
  \usepackage{classycv#1theme#2}%
}

%%
% Set submitter data
%%
\newcommand{\submitter}[1]{%
  \pgfkeys{/classycv/submitter/.cd, #1}%
}

%%
% Set recipient data
%%
\newcommand{\recipient}[1]{%
  \pgfkeys{/classycv/recipient/.cd, #1}%
}

%%
% Cover letter environment
%%%
\newenvironment{coverletter}{%
	\PackageError{classycv}{Please select a theme}{}
}{%
}

%%
% Resume environment
%%
\newenvironment{resume}{%
	\PackageError{classycv}{Please select a theme}{}
}{%
}

%%
% Local resume block environment
%%
\newenvironment{@classycv@resume@block}{%
  \PackageError{classycv}{Please select a theme}{}
}{%
}

%%
% Local resume entry command
%%
\newcommand{\@classycv@resume@entry}[4]{% 
  \PackageError{classycv}{Please select a theme}{}%
}

%%
% Local resume entry line command
%%
\newcommand{\@classycv@resume@entryline}[4]{% 
  \PackageError{classycv}{Please select a theme}{}%
}

%%
% Attachment environment
%%
\newenvironment{attachment}[1]{%
  \PackageError{classycv}{Please select a theme}{}
}{%
}

\newcommand{\@classycv@attachment@footer}{%
  \PackageError{classycv}{Please select a theme}{}
}

\makeatother