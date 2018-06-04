import cx from 'classnames'
import {Link} from 'react-router-dom'
import {Profile} from 'axon-brand'
import {ProfilePolygon} from 'axon-brand'
import React from 'react';
import styles from './run-report.css'
import TileMenu from '../tile-menu'

import fontawesome from '@fortawesome/fontawesome'

import FontAwesomeIcon from '@fortawesome/react-fontawesome'

import { faCoffee, faExclamationCircle, faPaintBrush, faHandshake, faClipboardList, faBan } from '@fortawesome/fontawesome-free-solid'

export default function () {

  return (
    <div className={styles.tile}>

    <TileMenu title="Connect and Apply" />

        <p className={styles.blueBG}>Connect to other registered thinkers who&#39;ve taken the HBDI and share your results to receive insights based on your combined profiles. Select one or more of the goals below to create your customized guide. Any guides you generate can be found in the <b>Your Connections</b> tile.
        </p>

      <form>
      <h3>I&#39;d like to:</h3>

        <div className={cx(styles.wrapper, styles.radioToolbar)}>

          <div className={styles.goal}>
          <input type="checkbox" id="check1" name="meetings"/>
          <label for="check1">
          <FontAwesomeIcon icon={["fas","coffee"]}/><br/>
          Hold more productive meetings</label>
          </div>

          <div className={styles.goal}>
          <input type="checkbox" id="check2" name="conflict"/>
          <label for="check2">
          <FontAwesomeIcon icon={["fas","exclamation-circle"]}/><br/>
          Manage and resolve conflict</label>
          </div>

          <div className={styles.goal}>
          <input type="checkbox" id="check3" name="creativity"/>
          <label for="check3">
          <FontAwesomeIcon icon={["fas","paint-brush"]}/><br/>
          Increase creativity and innovation</label>
          </div>

          <div className={styles.goal}>
          <input type="checkbox" id="check4" name="meetings"/>
          <label for="check4">
          <FontAwesomeIcon icon={["fas","handshake"]}/><br/>
          Improve collaboration</label>
          </div>

          <div className={styles.goal}>
          <input type="checkbox" id="check5" name="conflict"/>
          <label for="check5">
          <FontAwesomeIcon icon={["fas","clipboard-list"]}/><br/>
          Get organized</label>
          </div>

          <div className={styles.goal}>
          <input type="checkbox" id="check6" name="creativity"/>
          <label for="check6">
          <FontAwesomeIcon icon={["fas","ban"]}/><br/>
          Identify and remove obstacles</label>
          </div>

        </div>
        <button>
          Connect With Other Thinkers
        </button>
      </form>
    </div>
  )
}
