import cx from 'classnames'
import {Link} from 'react-router-dom'
import {Profile} from 'axon-brand'
import {ProfilePolygon} from 'axon-brand'
import React from 'react';
import styles from './invite.css'
import TileMenu from '../tile-menu'

export default function () {

  return (
    <div className={styles.tile}>

    <TileMenu title="Invite a Friend" />

        <p className={styles.blueBG}>Want to compare your HBDI<sup>&reg;</sup> profile with someone who hasn&#39;t taken the assessment yet? Invite them here and they can register with a special discounted price!</p>


      <br/>
      <form className={styles.wrapper}>
      <div className={styles.invite}>
        <p>First Name</p>
        <input type="text" name="firstname"/>
      </div>
      <div className={styles.invite}>
        <p>Last Name</p>
        <input type="text" name="lastname"/>
      </div>
      <div className={styles.invite}>
        <p>Email Address</p>
        <input type="text" name="email" className={styles.email}/>
      </div>

      </form>
      <button type="submit" value="Submit" className={styles.invite}>
      Invite
      </button>

    </div>
  )
}
