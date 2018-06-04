import React from 'react';
import styles from '../../video.css'

import VideoNav from '../video-nav'

const urls = {
  intro_video: "https://www.youtube.com/embed/3hIEoe-OPzo?rel=0",
  science_behind: "https://www.youtube.com/embed/t8aPUbJGFtg?rel=0",
  who_do_think_you_are: "https://www.youtube.com/embed/QfwobBgobN8?rel=0",
  recognizing_preferences: "",
  practices: ""
}

export default function ({match}) {
  return (
    <>
      <div className={styles.videoWrapper}>

      <iframe className={styles.videoEmbed} src={urls[match.params.videoId]} frameBorder="0" allow="autoplay; encrypted-media" allowFullScreen></iframe>
      </div>
      <VideoNav/>
    </>

  )
}
