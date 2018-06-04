export function selectTimelineData(state){

  return {
    completedEvents: [
      {
        id: 1,
        type: "thinker_registered",
        description: "Registering as a Thinker",
        linkTo: "/settings"
      },
      {
        id: 1432,
        type: "thinker_profile_generated",
        description: "Completing the HBDI",
        linkTo: "/results"
      },
      {
        id: 153424,
        type: "thinker_profile_unlocked",
        description: "Unlocking Your Results",
        linkTo: "/results"
      },
      {
        id: 4564,
        type: "thinker_debriefed",
        description: "Getting Debriefed",
        linkTo: "/results"
      }
    ],
    suggestedActivities: [
      {
        id: 4564,
        type: "video_1",
        description: "Watch the First Video",
        linkTo: "/watchvideo"
      },
      {
        id: 5685,
        type: "connect_team",
        description: "Connecting With Your Team",
        linkTo: "/results"
      },
      {
        id: 565,
        type: "invite",
        description: "Inviting a Friend",
        linkTo: "/results"
      }
    ]
  }
}
