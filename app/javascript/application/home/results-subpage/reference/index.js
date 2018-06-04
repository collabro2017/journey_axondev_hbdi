import React from 'react'
import cx from 'classnames'
import Icon from 'react-icon'

import styles from '../styles.css'
import blockLetter from './block-letter.css'
import alarm from './assets/alarm.svg'
import chart from './assets/chart.svg'
import heart from './assets/heart.svg'
import light from './assets/light.svg'

const icons = {
  A: chart,
  B: alarm,
  C: heart,
  D: light
}

const descriptions ={
  A: "bar chart icon",
  B: "alarm clock",
  C: "heart",
  D: "lightbulb"
}

export default class QuadrantLabel extends React.Component{

  render(){
    const letter = this.props.letter
    return (
      <div className={cx(styles.labelContainer,styles[letter],this.props.className)} key={letter}>
        <div className={cx(styles.label, styles[letter])}>
          <h3 className={cx(blockLetter.letter, blockLetter[letter], styles.letter)}>{letter}</h3>
          <div className={styles.descriptor}>
            <h4>
              {this.props.children}
              <Icon role="img" aria-label={descriptions[letter]} icon={icons[letter]} className={styles.icon} />
            </h4>
          </div>
        </div>
      </div>
    )
  }
}
