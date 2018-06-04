import React from 'react'
import cx from 'classnames'
import {connect} from 'react-redux'
import PropTypes from 'prop-types'

import styles from './styles.css'
import QuadrantLabel from './reference/quadrant-label.js'
import {Profile} from 'axon-brand'
import {ProfilePolygon} from 'axon-brand'
import TileMenu from '../components/tile-menu'
import SocialBar from '../components/social-bar'

import alarm from './reference/assets/alarm.svg'
import chart from './reference/assets/chart.svg'
import heart from './reference/assets/heart.svg'
import light from './reference/assets/light.svg'

const icons = {
  A: chart,
  B: alarm,
  C: heart,
  D: light
}

const numericalValidator = (props, propName) => parseInt(props[propName]) != NaN ? null : new Error("Prop`" + propName + "`suppplied to`" + componentName + "`must be numerical")

export class Main extends React.Component{

  static propTypes={
    preferenceCodes: PropTypes.shape({
      A: numericalValidator,
      B: numericalValidator,
      C: numericalValidator,
      D: numericalValidator
    }).isRequired,
    profileScores: PropTypes.shape({
      A: numericalValidator,
      B: numericalValidator,
      C: numericalValidator,
      D: numericalValidator
    }).isRequired,
    preferenceDescriptors: PropTypes.shape({
      A: PropTypes.string.isRequired,
      B: PropTypes.string.isRequired,
      C: PropTypes.string.isRequired,
      D: PropTypes.string.isRequired
    })
  };

  render(){
    return (
      <>
      <TileMenu title="Your HBDI&reg; Profile"/>
      <div className={styles.container}>
        <div>
          <h3>FName LName</h3>
          <p>The Whole Brain Model is a metaphorical model that describes one&#39;s thinking preferences. There are four quadrants of Thinking: <b>(A) Analytical, (B) Safe Keeping, (C) Interpersonal and (D) Experimental.</b> Which quadrants sound most like you? What quadrants sound least like you? Review your results below and consider where you may have seen your preferences play out in your daily life.</p>

          <div className={styles.content}>

          <QuadrantLabel letter="A">
            <div className={styles.box}>
               <img src={chart} className={styles.icon}/>
               <h4>Analytical:</h4>
               <span key="aQuadrantContent" className={styles.score}>2</span>
             </div>
          </QuadrantLabel>


          <QuadrantLabel letter="B">
            <div className={styles.box}>
              <img src={alarm} className={styles.icon}/>
              <h4>Practical:</h4>
              <span key="bQuadrantContent" className={styles.score}>2</span>
            </div>
          </QuadrantLabel>

          <QuadrantLabel letter="C">
            <div className={styles.box}>
              <img src={heart} className={styles.icon}/>
              <h4>Relational:</h4>
              <span key="cQuadrantContent" className={styles.score}>1</span>
            </div>
          </QuadrantLabel>

          <QuadrantLabel letter="D">
            <div className={styles.box}>
              <img src={light} className={styles.icon}/>
              <h4>Experiamental:</h4>
              <span key="dQuadrantContent" className={styles.score}>1</span>
            </div>
          </QuadrantLabel>

          </div>





          <div className={styles.profileContainer}>
            <svg key="model" width="100%" viewBox="0 0 100 100">
              <Profile />
              <ProfilePolygon strokeWidth={2} scores={{A: 55, B: 40, C: 75, D: 104}} />
            </svg>
          </div>

          <div className={styles.description}>
            <p>2111: This profile represents 10.25% of the Herrmann® database. This is a triple dominant profile with two primaries in the right mode, Lower Right C and Upper Right D quadrants and the third in Lower Left B: our database shows it to be the clear majority for the female population. The 2111 profile is characterized by its multi- dominant and 'generalized' nature, fairly balanced amount of understanding and ease of using the three primary quadrants. Preferred processing modes are creative and holistic (Upper Right D), interpersonal and feeling (Lower Right C), planning and organizing (Lower Left B).The Upper Left quadrant A is least preferred, but still the person is, typically, quite functional in their use of the logical and analytical aspects of this quadrant. This profile is typical of many personnel and human resource professionals, including teachers, as well as those whose occupations require an understanding and ability to function on many levels. Work that is considered a 'Turn- On' would include: Planning things out, providing support, designing, seeing the big picture, being part of a team, and helping people.
            </p>
          </div>
        </div>
      </div>
      <SocialBar/>
    </>
    )
  }
}

export default Main
