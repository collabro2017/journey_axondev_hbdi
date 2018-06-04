import cx from 'classnames'
import {Link} from 'react-router-dom'

import {Profile} from 'axon-brand'
import {ProfilePolygon} from 'axon-brand'
import React from 'react';

import styles from './journey-timeline.css';
import TileMenu from '../../../home/components/tile-menu'

import bar from './images/png/bar.png';
import map from './images/svg/journey.svg';
import bubble from './images/svg/bubble.svg';
import knowledge from './images/svg/knowledge.svg';
import hbdi from './images/svg/hbdi.svg';
import magnify from './images/svg/magnify.svg';
import video from './images/svg/video.svg';
import team from './images/svg/team.svg';
import idea from './images/svg/idea.svg';
import culture from './images/svg/culture.svg';

import {selectTimelineData} from '../../selectors.js'

const imageMap = {
  thinker_registered: hbdi,
  thinker_profile_unlocked: knowledge,
  thinker_debriefed: team,
  thinker_profile_generated: idea,
  video_1: video,
  connect_team: culture,
  invite: bubble
}

function renderEvent (e) {

  return (
    <div key={e.id} className={styles.event}>
      <a>
        <img className={styles.icon} src={ imageMap[e.type]}/>
        <p>{e.description}</p>
      </a>
    </div>
  )
}

export default function JourneyTimeline(props) {

return (
  < >

    <TileMenu title="Thinker Journey" />

    <div className={styles.flexWrap}>
    <img src={map} className={styles.journeyIcon}/>

    <h4>FName, keep exploring and learning with one of the suggeted activities below!</h4>
    </div>

    <div className={cx(styles.wrapper, styles.next)}>
      {
        (props.suggestedActivities || []).map(renderEvent)
      }
    </div>

    <img src={bar} className={styles.bar}/>

    <h3 className={styles.journeySubtitle}>You&#39;ve recently completed</h3>

    <div className={styles.wrapper}>
      {
        (props.completedEvents || []).map(renderEvent)
      }
    </div>

    <Link to="/journey">
      <h6 className={styles.small}>See all badges</h6>
    </Link>
</>
)
}
