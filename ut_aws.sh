#!/usr/bin/env zsh
ZSH_CONFIG_FOLDER="$HOME/.zshrc.d"
ZSH_DEFAULT_CONFIG_FILE="$HOME/.zshrc"
AWS_SCRIPT_PATH="$HOME/.zshrc.d/aws.sh"

# Check if you have zsh
if ! command -v zsh &> /dev/null
then
    echo "You need zsh for this script to work"
    exit 1
fi

# Check to see if ~/.zshrc.d folder exists
if [ -d "$ZSH_CONFIG_FOLDER" ]; then
    echo "$ZSH_CONFIG_FOLDER exists."
else
    # Create the folder if it doesn't
    echo "$ZSH_CONFIG_FOLDER does not exist. Creating..."
    mkdir $ZSH_CONFIG_FOLDER
fi

# Check to see if aws.sh file exists
if [ -f "$AWS_SCRIPT_PATH" ]; then
    echo "$AWS_SCRIPT_PATH already exists."
else
    # Create the file if it doesn't
    echo "$AWS_SCRIPT_PATH does not exist. Creating..."
    tee $AWS_SCRIPT_PATH <<\EOF > /dev/null
# A helper function to set your AWS Profile for proper execution context-switching
#
# usage:  a <aws_profile>
#
# Alias a() to get or set current aws profile
a() {
  NEWPROFILE=$1
  MYPROFILES=("${(@f)$(aws configure list-profiles)}")
  if [[ ${NEWPROFILE} == "--list" ]]; then
    if [[ -n "${AWS_DEFAULT_PROFILE}" ]]; then
      echo "Current profile is: ${AWS_DEFAULT_PROFILE}"
      return
    else
      echo "No profile set"
      return
    fi
  elif [[ -z ${NEWPROFILE} ]]; then
      echo -e "No profile passed. Please use one of...\n\t ${MYPROFILES[*]}"
      return
  fi
  # Check to see if the requested profile exists and change to it
  if [[ "${MYPROFILES[*]}" =~ ${NEWPROFILE} ]]; then
    echo "changing aws profile to: ${NEWPROFILE}"
    export AWS_DEFAULT_PROFILE=${NEWPROFILE}
  else
    echo -e "Profile: \`${NEWPROFILE}\` doesn't exist, please use one of...\n\t${MYPROFILES[*]}"
  fi
}
autoload bashcompinit && bashcompinit
autoload -Uz compinit && compinit
compinit
# completion stuff for `a` command
_acomp() {
    # this is comps function for a
    local profiles
    profiles=("${(@f)$(aws configure list-profiles)}")
    _arguments '--list'
    compadd ${profiles[@]}
}
compdef _acomp a
EOF
fi


# Check to see if ~/.zshrc file exists
if [ -f "$ZSH_DEFAULT_CONFIG_FILE" ]; then
    # Add source command to .zshrc
    if ! grep -q "source $AWS_SCRIPT_PATH" "$ZSH_DEFAULT_CONFIG_FILE"; then
      echo "source $AWS_SCRIPT_PATH" >> $ZSH_DEFAULT_CONFIG_FILE
    fi
    echo "Success. Please open a new terminal window or run 'source ~/.zshrc' to use the 'a' command"
    exit 0
else
    echo "$ZSH_DEFAULT_CONFIG_FILE doesn't exist. I'm not sure what to do. Change ZSH_DEFAULT_CONFIG_FILE variable"
    exit 1
fi
