import Announcements from './components/announcements/announcements.js'
import cx from 'classnames'
import Footer from './components/footer/footer.js'
import Header from './components/header/header.js'
import React from 'react';
import Results from './components/results/results.js'
import {JourneyTileContent} from '../journey'
import Video from '../video'
import Tile from './components/tile'
import SavedReports from './components/saved-reports/'
import RunReport from './components/run-report/'
import Invite from './components/invite/'
import styles from './styles.css'

export default class Layout extends React.Component {

  render(){

    return (
      <>
        <div className={styles.wrapper}>

          <Tile><Results/></Tile>

          <Tile><JourneyTileContent/></Tile>

          <RunReport/>

          <Tile><Video/></Tile>

          <Announcements/>

          <div className={styles.tile}><SavedReports/>
          </div>

          <Invite/>

        </div>

      </>
    )
  }
}
