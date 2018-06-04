import cx from 'classnames'
import {Link} from 'react-router-dom'

import React from 'react';
import styles from './video.css'
import TileMenu from '../home/components/tile-menu'
import Tile from '../home/components/tile'
import {t} from 'axon-i18n'

import videoIcon from '../journey/components/journey-timeline/images/svg/video.svg';

import video1Img from './images/video1.png';
import video2Img from './images/video2.png';
import video3Img from './images/video3.png';

export default function () {

  return (
    <>

    <TileMenu title="Video Library" />

    <div className={styles.wrapper}>
      <Link to="/videos/intro_video">
        <div className={cx(styles.video, styles.unlocked)}>
            <img src={video1Img}/>
            <p>{t("videos.introduction.title")}</p>
        </div>
      </Link>

        <Link to="/videos/science_behind">
      <div className={styles.video}>
          <img src={video2Img}/>
          <p>The Science Behind The Whole Brain Thinking Model</p>
      </div>
      </Link>

      <Link to="/videos/who_do_think_you_are">
      <div className={styles.video}>
          <img src={video3Img}/>
          <p>Who Do You Think You Are?</p>
      </div>
      </Link>

      <div className={styles.video}>
          <img src={videoIcon}/>
          <p>Recognizing the Preferences of Others</p>
      </div>

      <div className={styles.video}>
          <img src={videoIcon}/>
          <p>Putting Your Results into Practice</p>
      </div>
    </div>

    </>

  )
}
