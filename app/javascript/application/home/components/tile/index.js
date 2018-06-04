import cx from 'classnames'
import React from 'react';

import styles from './tile.css'
import TileMenu from '../tile-menu'

export default function (props) {

  return (
    <div className={cx(styles.tile, props.className)}>
      {props.children}
    </div>
  )
}
