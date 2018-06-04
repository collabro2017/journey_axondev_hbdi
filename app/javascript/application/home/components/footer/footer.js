import React from 'react';
import styles from '../../styles.css'

export default function () {

var year = new Date().getFullYear();

      return (
        <>
        <br/><br/>
        <div className={styles.footer}>
          <p>&copy; 1981-{year} Herrmann Global, LLC</p>

          <a href="https://www.herrmannsolutions.com/contact-us/" target="_blank">Contact Us</a>
        </div>
        </>
      )
    }
