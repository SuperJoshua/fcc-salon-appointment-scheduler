#! /bin/bash

PSQL="psql -d salon -U freecodecamp -t -X -c"

echo -e "\n--- Git It Dun ---\n"

POSITIVE_RESPONSES=("Sure thing." "Are you sure, hun?" "Now, why'd you wanna do that, fur? Whatever..." "I was thinking the same thing!" "Now, wouldn't that look nice?" "Okiedokie!" "Hmm. Ya think I could get away with that, too? Just fooling!")
POSITIVE_RESPONSES_LENGTH=7

NEGATIVE_RESPONSES=("Sorry, hun, I have no idea what yer talking about." "Excuse me? I wasn't listening." "You'll have to speak up -- the music's a little loud in here." "LEEROY! TURN DOWN THAT MUSIC! Sorry, hun, you were saying?" "Hmm? Sorry. I think I stayed up too late, last night.")
NEGATIVE_RESPONSES_LENGTH=5

SERVICE_MENU() {
   if [[ $1 ]]
   then
      echo -e "\n$1"
   fi

   echo -e "Howdy and welcome to Git it Dun.\nHow can we make yer day a *GID* one?\n"
   SERVICES_AVAILABLE=$($PSQL "select service_id, name from services")
   echo "$SERVICES_AVAILABLE" | while read SERVICE_ID BAR SERVICE_NAME
      do
      echo -e "$SERVICE_ID) $SERVICE_NAME"
   done

   echo ""
   # this is the only input that's reasonably restriced
   # looks like the freecodecamp tests can't abide prompts
   #read -p "Anything catch your eye? " SERVICE_ID_SELECTED
   echo "Anything catch your eye? "
   read SERVICE_ID_SELECTED
   SERVICE_NAME=$($PSQL "select name from services where service_id = $SERVICE_ID_SELECTED" | sed -E 's/^ *//')
   if [[ -z $SERVICE_NAME ]]
   then
      R=$(($RANDOM % $NEGATIVE_RESPONSES_LENGTH))
      RANDOM_RESPONSE=${NEGATIVE_RESPONSES[$R]}
      SERVICE_MENU "$RANDOM_RESPONSE\n"
   else
      R=$(($RANDOM % $POSITIVE_RESPONSES_LENGTH))
      RANDOM_REPONSE=${POSITIVE_RESPONSES[$R]}
      echo -e "$(echo $SERVICE_NAME | sed -E 's/(\w)/\U\1/')? $RANDOM_REPONSE"
      # valid phone number? anything that isn't more than 15 characters...
      # looks like the freecodecamp tests can't abide prompts
      #read -p "What's yer phone number? " CUSTOMER_PHONE
      echo "What's yer phone number? "
      read CUSTOMER_PHONE
      PHONE=$($PSQL "select phone from customers where phone = '$CUSTOMER_PHONE'" | sed -E 's/^ *//')
      if [[ -z $PHONE ]]
      then
         # real name, fake name, name with numbers and odd punctuation -- all accepted
         # looks like the freecodecamp tests can't abide prompts
         #read -p "Oh! Looks like you're new here. What'll we call you? " CUSTOMER_NAME
         echo "Oh! Looks like you're new here. What'll we call you? "
         read CUSTOMER_NAME
         $PSQL "insert into customers(name, phone) values('$CUSTOMER_NAME', '$CUSTOMER_PHONE')"
      fi
      CUSTOMER_NAME=$($PSQL "select name from customers where phone = '$CUSTOMER_PHONE'" | sed -E 's/^ *//')
      CUSTOMER_ID=$($PSQL "select customer_id from customers where phone = '$CUSTOMER_PHONE'")
      # presumably, the user will enter something like 11:45, and not "in the future"
      # looks like the freecodecamp tests can't abide prompts
      #read -p "And when should you like that done, $CUSTOMER_NAME? " SERVICE_TIME
      echo "And when should you like that done, $CUSTOMER_NAME? "
      read SERVICE_TIME
      $PSQL "insert into appointments(time, customer_id, service_id) values('$SERVICE_TIME', $CUSTOMER_ID, $SERVICE_ID_SELECTED)"
      echo "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
      # Not sure why the valediction had to be so stiff. Below lies the former.
      #echo "Alrighty, $NAME, it looks like we'll $SERVICE_NAME at $SERVICE_TIME. See you then!"
   fi
}


SERVICE_MENU
