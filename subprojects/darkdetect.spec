%global python3_pkgversion 3.11

Name:           python-darkdetect
Version:        1.0.0
Release:        1%{?dist}
Summary:        Darkdetect Python library

License:        Custom License
URL:            https://github.com/albertosottile/darkdetect
Source0:         darkdetect-1.0.0.tar.gz

BuildArch:      noarch
BuildRequires:  python%{python3_pkgversion}-devel                     

# Build dependencies needed to be specified manually
BuildRequires:  python%{python3_pkgversion}-setuptools


%global _description %{expand:
Darkdetect is a library that detect OS dark or light mode.}

%description %_description

%package -n python%{python3_pkgversion}-darkdetect                         
Summary:        %{summary}

%description -n python%{python3_pkgversion}-darkdetect %_description


%prep
%autosetup -p1 -n darkdetect-%{version}


%build
# The macro only supported projects with setup.py
%py3_build                                                            


%install
# The macro only supported projects with setup.py
%py3_install


%check                                                                
%{pytest}


# Note that there is no %%files section for the unversioned python module
%files -n python%{python3_pkgversion}-darkdetect
%doc README.md
%license LICENSE